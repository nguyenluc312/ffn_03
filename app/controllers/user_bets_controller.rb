class UserBetsController < ApplicationController
  load_and_authorize_resource

  def index
    @user_bets = current_user.user_bets
  end

  def create
    if @user_bet.save
      respond_to do |format|
        format.html{redirect_to :back}
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def user_bet_params
    params.require(:user_bet).permit :user_id, :match_id, :coin, :chosen
  end
end
