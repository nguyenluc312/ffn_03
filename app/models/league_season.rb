class LeagueSeason < ActiveRecord::Base
  belongs_to :league
  has_many :matches
  has_many :player_awards
  has_many :season_teams

  validates :year, uniqueness: {scope: :league}
  validate :check_season_team

  accepts_nested_attributes_for :season_teams, allow_destroy: true
  delegate :name, to: :league

  # def name
  #   I18n.t "league_seasons.name", league_name: self.league.name,
  #     start_year: self.year, end_year: self.year + 1
  # end

  private
  def check_season_team
    season_teams = self.season_teams.reject {|season_team| season_team.marked_for_destruction?}
    if season_teams.count < Settings.league_season.min_team_of_league
      self.errors.add :season_teams, I18n.t(".team_less_than_four")
    elsif season_teams.combination(2).any? {|s1, s2| s1.team_id == s2.team_id}
      self.errors.add :season_teams, I18n.t(".team_not_same")
    end
  end
end
