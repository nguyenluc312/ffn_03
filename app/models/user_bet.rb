class UserBet < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  enum chosen: [:team1, :draw, :team2]

  validates :chosen, presence: true
  validates :coin, presence: true

  def update_user_coin
    self.user.update_attribute :coin, self.user.coin - self.coin
  end
end
