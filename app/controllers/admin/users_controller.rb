class Admin::UsersController < ApplicationController
  before_action :load_user, only: [:destroy]

  def index
    @users = User.order("created_at DESC").page(params[:page])
      .per Settings.per_page
  end
  def destroy
    if @user.destroy
      flash[:success] = t "views.admin.flash.success"
    else
      flash[:danger] = t "views.admin.flash.failed"
    end
    redirect_to admin_users_url
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
  end
end
