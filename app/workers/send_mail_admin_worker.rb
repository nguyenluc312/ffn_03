class SendMailAdminWorker
  include Sidekiq::Worker

  def perform user_bet_id
    user_bet = UserBet.find_by id: user_bet_id
    admins = User.admin
    admins.each do |admin|
      AdminMailer.when_user_make_a_bet(admin, user_bet).deliver_now
    end
  end
end
