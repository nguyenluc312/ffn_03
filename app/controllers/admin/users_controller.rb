class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource
  before_action :load_user, only: [:destroy]

  def index
    @search = User.search params[:q]
    @users = @search.result.page(params[:page]).per Settings.users.per_page
  end

  def update
    if @user.moderate?
      @user.update_attribute :role, :user
    else
      @user.update_attribute :role, :moderate
    end
    redirect_to :back
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to :back
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
  end
end
