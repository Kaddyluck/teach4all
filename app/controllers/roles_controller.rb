class RolesController < ApplicationController
  before_action :set_organization
  def create
    clear_role
    @role = @organization.roles.build(role_params)
    authorize(@role)
    if @role.save
      flash[:success] = (params[:role] == 'org_admin' ? 'Admin' : 'User') +
                        ' was successfully added to organization'
    else
      flash[:danger] = @role.errors.full_messages.join('')
    end
    redirect_back fallback_location: organization_path(@organization)
  end

  def update
    @role = @organization.roles.find_by(user_id: params[:user_id])
    authorize(@role)
    if @role.update(role: params[:role])
      flash[:success] = 'Admin access was deleted successfuly'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to add_admins_to_organization_path(@organization)
  end

  def new
    @role = @organization.roles.build
    authorize(@role)
  end

  def destroy
    @role = @organization.roles.find_by(user_id: params[:user_id])
    authorize(@role)
    if @role.destroy
      flash[:success] = 'User was excluded successfuly'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to add_users_to_organization_path(@organization)
  end

  private

  def role_params
    params.require(:role).permit(:user_id, :role)
  end

  def clear_role
    @role = @organization.roles.find_by(user_id: role_params[:user_id])
    @role.destroy if @role.present?
  end

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
end
