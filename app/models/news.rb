class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type
  has_many :comments, dependent: :destroy
  mount_uploader :represent_image, PhotoUploader
  validates :title, presence: true, length: {maximum: 200}
  validates :news_type_id, presence: true
  validates :brief_description, presence: true, length: {maximum: 1000}
  validates :content, presence: true, length: {maximum: 10000}
  validates :author, presence: true, length: {maximum: 100}
  validates :represent_image, presence: true
  validate :image_size
  delegate :name, to: :news_type, prefix: true

  class << self
    def hot_news
      News.order(comments_count: :desc, created_at: :desc)
        .where(":date <= created_at", date: Settings.news.hot_days_ago.days.ago.to_date)
        .limit Settings.news.hot_news
    end
  end

  private
  def image_size
    if represent_image.size > Settings.image.max_capacity.megabytes
      errors.add :represent_image,
        I18n.t("error_capacity_image", maximum: Settings.image.max_capacity)
    end
  end
end
