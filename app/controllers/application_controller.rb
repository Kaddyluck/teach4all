class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  impersonates :user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :first_name, :last_name])
  end

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action"
    redirect_back fallback_location: root_path
  end
end
