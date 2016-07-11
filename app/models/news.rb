class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type

  validates :title, presence: true, length: {maximum: 200}
  validates :news_type_id, presence: true
  validates :brief_description, presence: true, length: {maximum: 1000}
  validates :content, presence: true, length: {maximum: 10000}
  validates :author, presence: true, length: {maximum: 100}
end
