class UsersController < ApplicationController

  def show
    @user = User.find_by id: params[:id]
    @activities = PublicActivity::Activity.where(owner: @user)
      .order(created_at: :desc)
      .page(params[:page]).per Settings.activity.per_page
  end
end
