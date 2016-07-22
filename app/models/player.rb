class Player < ActiveRecord::Base
  enum position: [:goalkeeper, :defender, :midfielder, :striker]
  belongs_to :team
  belongs_to :country
  has_many :player_awards
  mount_uploader :avatar, PlayerAvatarUploader
  validates :name, presence: true, length: {maximum: 50}
  validates :avatar, :date_of_birth, :country, :position, presence: true
  validates :introduction, allow_nil: true, length: {maximum: 1000, minimum: 50}
  delegate :name, to: :country, prefix: true

  def current_team
  end

  def team_mates
  end
end
