class League < ActiveRecord::Base
  belongs_to :country
  has_many :league_seasons

  validates :name, presence: true, uniqueness: true
  validates :founded_at, :country, presence: true
end
