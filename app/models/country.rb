class Country < ActiveRecord::Base
  has_many :leagues
  has_many :players
  has_many :teams
end
