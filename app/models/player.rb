class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :country
  has_many :player_awards
end
