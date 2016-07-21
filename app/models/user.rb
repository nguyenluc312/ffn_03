class User < ActiveRecord::Base
  enum role: [:user, :admin]

  has_many :news
  has_many :comments
  has_many :user_bets
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, ImageUploader
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, omniauth_providers: [:facebook]
  validates :name, presence: true, length: {maximum: 50}
  validate :image_size

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
      end
    end

    def new_with_session params, session
      super.tap do |user|
        if data = session["devise.facebook_data"] &&
          session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end

  private
  def image_size
    if avatar.size > Settings.image.max_capacity.megabytes
      errors.add :avatar,
        I18n.t("error_capacity_image", maximum: Settings.image.max_capacity)
    end
  end
end
