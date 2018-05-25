class UsersController < ApplicationController
  def impersonate
    @user = User.find(params[:id])
    authorize(@user)
    @impersonation = Impersonation.create impersonator: current_user,
                                           target_user: @user
    impersonate_user(@user)
    session[:back_url] = request.referrer
    flash[:warning] = "You are now impersonating @#{@user.nickname}"
    redirect_to root_path
  end
  
  def show
    @user = User.find(params[:id])
    @certificates = @user.certificates
  end

  def stop_impersonation
    authorize_by_true_user
    @impersonator = true_user
    @target_user = current_user
    @impersonation = Impersonation.where(impersonator: @impersonator,
                                         target_user: @target_user,
                                         ended_at: nil).last
    stop_impersonating_user
    @impersonation.update(ended_at: Time.zone.now) if @impersonation
    flash[:warning] = "You've stopped impersonating @#{@target_user.nickname}"
    redirect_to session[:back_url] || orgadmin_dashboard_path
  end

  private

  def authorize_by_true_user
    unless UserPolicy.new(true_user, current_user).stop_impersonation?
      raise Pundit::NotAuthorizedError
    end
  end
end
