class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type
end
