class SendMailBetResultWorker
  include Sidekiq::Worker

  def perform match_id
    match = Match.find_by id: match_id
    match.user_bets.each do |user_bet|
      UserMailer.user_bet_result(user_bet).deliver_now
    end
  end
end
