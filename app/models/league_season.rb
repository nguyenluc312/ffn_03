class LeagueSeason < ActiveRecord::Base
  belongs_to :league
  has_many :matches
  has_many :player_awards
  has_many :season_teams
end
