class UserMailer < ApplicationMailer

  def user_bet_result user_bet
    @user_bet = user_bet
    mail to: @user_bet.user.email,
      subject: I18n.t("mail.users.subject")
  end

  def inform_matches_tomorrow user, matches
    @user = user
    @matches = matches
    mail to: @user.email,
      subject: I18n.t("user_mailer.inform_matches_tomorrow.subject",
      date: 1.day.from_now.strftime(Settings.format.date))
  end
end
