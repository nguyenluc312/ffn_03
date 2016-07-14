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

  delegate :name, to: :news_type, prefix: true
end
