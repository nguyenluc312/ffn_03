class Match < ActiveRecord::Base
  enum status: [:not_started_yet, :is_on, :finished]

  belongs_to :league_season
  belongs_to :team1, class_name: Team.name
  belongs_to :team2, class_name: Team.name
  has_many :match_events, dependent: :destroy
  has_many :user_bets

  validates :team1, :team2, :start_time, :status,
    :team1_odds, :team2_odds, :draw_odds, presence: true
  validate :check_start_time, :validate_team_not_same, :check_time_is_on
  before_validation :validate_match, on: :create
  before_validation :check_update_when_match_is_on,
    :check_update_when_match_finished, on: :update

  scope :of_team_be_team1, ->(team_id, league_season_id) do
    where(team1_id: team_id).where(league_season_id: league_season_id)
  end
  scope :of_team_be_team2, ->(team_id, league_season_id) do
    where(team2_id: team_id).where(league_season_id: league_season_id)
  end
  scope :on_date, ->(date){where ":date = date(start_time)", date: date}

  after_save :start_match_job
  after_destroy :remove_user_bet
  before_save :set_goal_in_match

  ransacker :start_time do
    Arel.sql "date(start_time)"
  end

  def label_for_status
    case
    when self.not_started_yet?
      "info"
    when self.is_on?
      "warning"
    when self.finished?
      "success"
    end
  end

  def winner
    return nil unless self.finished?
    case
    when self.team1_goal > team2_goal
      self.team1
    when self.team1_goal < team2_goal
      self.team2
    end
  end

  def result
    if self.finished?
      case self.winner
      when self.team1
        "team1"
      when self.team2
        "team2"
      else
        "draw"
      end
    end
  end

  def start
    self.update_attributes status: :is_on, team1_goal: 0, team2_goal: 0
    Delayed::Job.enqueue FinishMatchJob.new(self.id), 1, Settings.match.duration.minutes.from_now
  end

  def finish
    unless self.finished?
      self.update_attributes status: :finished
      update_user_coin_when_match_end
      send_mail_bet_result
    end
  end

  class << self
    def inform_tomorrow_matches
      SendMailTomorrowMatchesWorker.perform_async
    end
  end

  private
  def validate_team_not_same
    if self.team1 && self.team2 && self.team1_id == self.team2_id
      self.errors.add :team, I18n.t(".team_not_same")
    end
  end

  def validate_match
    if Match.of_team_be_team1(self.team1_id,self.league_season_id)
      .of_team_be_team2(self.team2_id, self.league_season_id).any?
      self.errors.add :match, I18n.t(".match_invalid")
    end
  end

  def check_start_time
    if self.status && self.start_time
      if self.not_started_yet? && self.start_time < Time.zone.now
        self.errors.add :match, I18n.t(".start_time_must_larger_than_now")
      elsif (self.finished? || self.is_on?) && self.start_time > Time.zone.now
        self.errors.add :match, I18n.t(".start_time_must_less_than_now",
          status: self.status)
      end
    end
  end

  def check_time_is_on
    if self.start_time  && self.start_time < Time.zone.now - (Settings.match.minute_of_match).minutes
      self.errors.add :start_time, I18n.t(".start_time_must_in_minutes_ago",
        number: Settings.match.minute_of_match)
    end
  end

  def start_match_job
    if self.valid? && self.not_started_yet?
      if self.delayed_job_id
        Delayed::Job.find(self.delayed_job_id).update_attributes run_at: self.start_time
      else
        job = Delayed::Job.enqueue StartMatchJob.new(self.id), 1, self.start_time
        self.update_column :delayed_job_id, job.id
      end
    end
  end

  def check_update_when_match_is_on
    if self.status_was == "is_on"
      if self.start_time_changed?
        self.errors.add(:match, I18n.t("match.is_on.start_time_change"))
        self.reload
      end
      if self.team1_odds_changed? || self.team2_odds_changed?
        self.errors.add :match, I18n.t("match.is_on.odds_change")
        self.reload
      end
    end
  end

  def check_update_when_match_finished
    if self.status_was == "finished"
      self.errors.add(:match, I18n.t("match.finished")) if self.changed?
    end
  end

  def update_user_coin_when_match_end
    self.user_bets.each do |user_bet|
      if user_bet.is_correct?
        user_bet.user.update_attribute :coin,
          user_bet.user.coin + user_bet.coin * self.send(self.result + "_odds")
      end
    end
  end

  def send_mail_bet_result
    if self.finished?
      SendMailBetResultWorker.perform_async self.id
    end
  end

  def remove_user_bet
    if self.finished? || self.user_bets.blank?
      self.user_bets.destroy_all
    end
  end

  def set_goal_in_match
    if self.is_on? || self.finished?
      self.team1_goal ||= 0
      self.team2_goal ||= 0
    end
  end
end
