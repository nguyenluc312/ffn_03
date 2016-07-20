class UserBet < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  enum chosen: [:team1, :draw, :team2]

  validates :chosen, presence: true
  validates :coin, presence: true

  after_create :update_user_coin, :send_email_to_admin

  def update_user_coin
    self.user.update_attribute :coin, self.user.coin - self.coin
  end

  private
  def send_email_to_admin
    SendMailAdminWorker.perform_async self.id
  end
end
