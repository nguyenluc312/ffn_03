class SendMailTomorrowMatchesWorker
  include Sidekiq::Worker

  def perform
    matches = Match.on_date(1.day.from_now.to_date).order :start_time
    if matches.any?
      users = User.user
      users.each do |user|
        UserMailer.inform_matches_tomorrow(user, matches).deliver
      end
    end
  end
end
