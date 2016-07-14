class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:warning] = t "application.not_found"
    redirect_to root_url
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.for :sign_up do |user_params|
      user_params.permit :name, :email, :password, :password_confirmation,
        :avatar
    end

    devise_parameter_sanitizer.for :account_update do |user_params|
      user_params.permit :name, :email, :password, :password_confirmation,
        :avatar, :current_password
    end
  end
end
