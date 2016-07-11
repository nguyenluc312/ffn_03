class User < ActiveRecord::Base
  has_many :news
  has_many :comments
  has_many :user_bets
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, ImageUploader
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true, length: {maximum: 50}
  validate :image_size

  private
  def image_size
    if avatar.size > Settings.image.max_capacity.megabytes
      errors.add :avatar,
        I18n.t("error_capacity_image", maximum: Settings.image.max_capacity)
    end
  end
end
