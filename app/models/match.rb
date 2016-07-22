class Match < ActiveRecord::Base
  enum status: [:not_started_yet, :is_on, :finished]

  belongs_to :league_season
  belongs_to :team1, class_name: Team.name
  belongs_to :team2, class_name: Team.name
  has_many :match_events
  has_many :user_bets

  validates :team1, :team2, :start_time, :status,
    :team1_odds, :team2_odds, :draw_odds, presence: true
  validate :validate_team_not_same
  validate :check_start_time
  before_validation :validate_match, on: :create

  scope :of_team_be_team1, ->(team_id, league_season_id) do
    where(team1_id: team_id).where(league_season_id: league_season_id)
  end
  scope :of_team_be_team2, ->(team_id, league_season_id) do
    where(team2_id: team_id).where(league_season_id: league_season_id)
  end

  after_update :update_user_coin_when_match_end

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

  def update_user_coin_when_match_end
    self.user_bets.each do |user_bet|
      if user_bet.is_correct?
        user_bet.user.update_attribute :coin,
          user_bet.user.coin + user_bet.coin * self.send(self.result + "_odds")
      end
    end
  end
end
