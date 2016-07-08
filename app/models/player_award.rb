class PlayerAward < ActiveRecord::Base
  belongs_to :player
  belongs_to :league_season
end
