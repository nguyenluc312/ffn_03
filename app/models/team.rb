class Team < ActiveRecord::Base
  belongs_to :country
  has_many :matches
  has_many :players
  has_many :season_teams

  mount_uploader :logo, LogoTeamUploader

  validates :name, presence: true, uniqueness: true, length: {maximum: 200}
  validates :introduction, length: {maximum: 10000}
  validates :country, presence: true

  scope :in_country, ->(country_id){where country_id: country_id}
end
