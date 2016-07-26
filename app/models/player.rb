class Player < ActiveRecord::Base
  enum position: [:goalkeeper, :defender, :midfielder, :striker]
  belongs_to :country
  has_many :player_awards
  belongs_to :team
  mount_uploader :avatar, PlayerAvatarUploader
  validates :name, presence: true, length: {maximum: 50}
  validates :avatar, :date_of_birth, :country, :position, presence: true
  validates :introduction, allow_nil: true, length: {maximum: 1000}
  validates :squad_number, presence: true, uniqueness: {scope: :team}, if: :in_team?
  validates :joined_at, presence: true, if: :in_team?
  validate :check_joined_date, if: :in_team?
  validate :image_size
  delegate :name, to: :country, prefix: true
  delegate :name, to: :team, prefix: true, allow_nil: true
  delegate :logo, to: :team, prefix: true
  scope :free, -> {where team_id: nil}

  def age
    Time.zone.now.year - date_of_birth.year
  end

  private
  def image_size
    if avatar.size > Settings.image.max_capacity.megabytes
      errors.add :avatar,
        I18n.t("error_capacity_image", maximum: Settings.image.max_capacity)
    end
  end

  def in_team?
    self.team
  end

  def check_joined_date
    if joined_at && joined_at > Time.zone.now
      errors.add :joined_at, I18n.t(".errors")
    end
  end
end
