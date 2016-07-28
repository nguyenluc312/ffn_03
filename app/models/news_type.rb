class NewsType < ActiveRecord::Base
  has_many :news, dependent: :destroy

  validates :name, presence: true, length: {maximum: 100},
    uniqueness: {case_sensitive: false}

  class << self
    def preview_news_in_types
      res = Hash.new
      news_types = NewsType.includes :news
      news_types.each do |news_type|
        res[news_type] = news_type.news.sort{|n1, n2| n2.created_at <=> n1.created_at}
          .first Settings.news.preview_newest_in_types
      end
      res
    end
  end
end
