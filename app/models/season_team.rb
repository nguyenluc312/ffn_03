class SeasonTeam < ActiveRecord::Base
  belongs_to :league_season
  belongs_to :team
  has_many :team_achievements
end
