class Admin::BaseController < ApplicationController
  before_action :verify_admin

  private
  def verify_admin
    unless user_signed_in? && (current_user.admin? || current_user.moderate?)
      flash[:danger] = t "admin.verify_admin"
      redirect_to root_url
    end
  end
end
