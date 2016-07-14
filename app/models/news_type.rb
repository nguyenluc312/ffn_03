class NewsType < ActiveRecord::Base
  has_many :news, dependent: :destroy

  validates :name, presence: true, length: {maximum: 100},
    uniqueness: {case_sensitive: false}
end
