class UserMailer < ApplicationMailer

  def user_bet_result user_bet
    @user_bet = user_bet
    mail to: @user_bet.user.email,
      subject: I18n.t("mail.users.subject")
  end
end
