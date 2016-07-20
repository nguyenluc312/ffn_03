class Match < ActiveRecord::Base
  enum status: [:not_started_yet, :is_on, :finished]

  belongs_to :league_season
  belongs_to :team1, class_name: Team.name
  belongs_to :team2, class_name: Team.name
  has_many :match_events
  has_many :user_bets

  validates :team1_odds, :team2_odds, :draw_odds, presence: true
  validate :validate_team_not_same, :validate_max_match_of_team,
    :validate_match_of_two_team
  before_validation :validate_start_time, on: :create
  before_validation :validate_end_time, on: :update
  scope :of_team, ->(team_id, league_season_id) do
    where("team1_id = #{team_id}
    OR team2_id = #{team_id} AND league_season_id = #{league_season_id}")
  end
  scope :of_team_vs_team, ->(team1_id, team2_id, league_season_id) do
    Match.of_team(team1_id, league_season_id).of_team(team2_id, league_season_id)
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

  private
  def validate_team_not_same
    if self.team1_id == self.team2_id
      self.errors.add :team, I18n.t(".team_not_same")
    end
  end

  def validate_start_time
    if self.start_time < Time.zone.now
      self.errors.add :start_time, I18n.t(".larger_now")
    end
  end

  def validate_max_match_of_team
    max_match_of_team = self.league_season.season_teams.count * 2 - 2
    if Match.of_team(self.team1_id, self.league_season_id).count >= max_match_of_team
      self.errors.add :matches_of_team1,
        I18n.t(".max_match_of_team", max_match_of_team: max_match_of_team)
    end

    if Match.of_team(self.team2_id, self.league_season_id).count >= max_match_of_team
      self.errors.add :matches_of_team2,
        I18n.t(".max_match_of_team", max_match_of_team: max_match_of_team)
    end
  end

  def validate_match_of_two_team
    if Match.of_team_vs_team(self.team1_id, self.team2_id, self.league_season_id).count >= 2
      self.errors.add :match, I18n.t(".match_of_two_team")
    end
  end

  def validate_end_time
    if self.end_time && self.end_time <= self.start_time
      self.errors.add :end_time, I18n.t(".end_time_larger_than_start")
    end
  end
end
