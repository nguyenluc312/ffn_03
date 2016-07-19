class MatchesController < ApplicationController
  load_and_authorize_resource

  def show
    @user_bet = UserBet.new
  end
end
