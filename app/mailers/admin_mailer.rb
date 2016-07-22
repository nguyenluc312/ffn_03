class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.user_make_a_bet.subject
  #

  def when_user_make_a_bet admin, user_bet
    @user_bet = user_bet
    mail to: admin.email , subject: I18n.t(".user_bet")
  end
end
