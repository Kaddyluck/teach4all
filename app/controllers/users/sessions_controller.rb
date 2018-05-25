class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    close_unfinished_impersonations
  end

  # DELETE /resource/sign_out
  def destroy
    close_unfinished_impersonations unless current_user == true_user
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def close_unfinished_impersonations
    unfinished_impersonations = true_user.impersonations_as_impersonator.not_ended
      if unfinished_impersonations.any?
        unfinished_impersonations.update_all(ended_at: Time.zone.now)
      end
  end
end
