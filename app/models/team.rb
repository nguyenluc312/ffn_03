class Team < ActiveRecord::Base
  belongs_to :country
  has_many :matches
  has_many :players
  has_many :season_teams
end
