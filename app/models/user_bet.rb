class UserBet < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  enum chosen: [:team1, :draw, :team2]

  validates :chosen, presence: true
  validates :coin, presence: true
  validate :match_out_of_bet, :max_coin_of_user_bet

  after_create :update_user_coin, :send_email_to_admin

  include PublicActivity::Model
  tracked only: :create, owner: :user, recipient: :match

  def update_user_coin
    self.user.update_attribute :coin, self.user.coin - self.coin
  end

  def is_correct?
    self.chosen == self.match.result
  end

  private
  def send_email_to_admin
    SendMailAdminWorker.perform_async self.id
  end

  def match_out_of_bet
    if self.match.finished? || self.match.is_on?
      self.errors.add :match, I18n.t(".match_out_of_bet", status: self.match.status.to_s)
    end
  end

  def max_coin_of_user_bet
    if self.coin > self.user.coin
      self.errors.add :coin, I18n.t("user_bets.max_coin", coin: self.user.coin)
    end
  end
end
