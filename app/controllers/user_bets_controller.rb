class UserBetsController < ApplicationController
  load_and_authorize_resource

  def index
    @user_bets = current_user.user_bets.order(created_at: :desc)
      .page(params[:page]).per Settings.user_bets.per_page
  end

  def create
    if @user_bet.save
      flash.now[:success] = t ".success"
    end
    respond_to do |format|
      format.js
    end
  end

  private
  def user_bet_params
    params.require(:user_bet).permit :user_id, :match_id, :coin, :chosen
  end
end
