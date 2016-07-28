class Country < ActiveRecord::Base
  has_many :leagues
  has_many :players
  has_many :teams
  has_many :league_seasons, through: :leagues

  validates :code, presence: true, uniqueness: true
  validates :flag, presence: true
  validate :image_size

  before_save :set_name

  mount_uploader :flag, CountryFlagUploader

  private
  def set_name
    country = ISO3166::Country[self.code]
    self.name = country.translations[I18n.locale.to_s] || country.name
  end

  def image_size
    if flag.size > Settings.image.max_capacity.megabytes
      errors.add :flag,
        I18n.t("error_capacity_image", maximum: Settings.image.max_capacity)
    end
  end
end
