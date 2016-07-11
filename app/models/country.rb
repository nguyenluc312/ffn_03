class Country < ActiveRecord::Base
  has_many :leagues
  has_many :players
  has_many :teams

  validates :code, uniqueness: true

  before_save :set_name

  private
  def set_name
    country = ISO3166::Country[self.code]
    self.name = country.translations[I18n.locale.to_s] || country.name
  end
end
