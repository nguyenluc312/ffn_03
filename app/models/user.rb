class User < ActiveRecord::Base
  has_many :news
  has_many :comments
  has_many :user_bets
end
