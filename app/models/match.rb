class Match < ActiveRecord::Base
  belongs_to :league_season
  belongs_to :team1, class_name: User.name
  belongs_to :team2, class_name: User.name
  has_many :match_events
  has_many :user_bets
end
