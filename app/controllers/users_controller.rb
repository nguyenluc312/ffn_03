class UsersController < ApplicationController

  def show
    @activities = PublicActivity::Activity.order(created_at: :desc)
      .page(params[:page]).per Settings.activity.per_page
    @user = User.find_by id: params[:id]
  end
end
