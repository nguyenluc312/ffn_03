class LeagueSeason < ActiveRecord::Base
  belongs_to :league
  has_many :matches
  has_many :player_awards
  has_many :season_teams

  validates :year, uniqueness: {scope: :league}
  validate :check_season_team

  accepts_nested_attributes_for :season_teams, allow_destroy: true
  delegate :name, to: :league

  def get_schedule
    self.matches.includes(:team1, :team2).group_by{|match| match.start_time.to_date}
  end

  def get_rank
    season_teams = self.season_teams.includes :team
    matches = self.matches.includes :team1, :team2
    season_teams.each do |season_team|
      team = season_team.team
      team.set_init_value
      matches.each do |match|
        team.stats_from_match match
      end
    end
    res = season_teams.map{|season_team| season_team.team}
    res.sort! {|t1, t2| [t2.score, t2.offset, t1.name] <=> [t1.score, t1.offset, t2.name]}
    res.each_with_index do |team, index|
      index > 0 && team.same_achievement?(res[index-1]) ? team.rank = res[index-1].rank
        : team.rank = index + 1
    end
    res
  end

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
