class OrganizationsController < ApplicationController
  require 'csv'
  before_action :set_organization, except: %i[new create index]

  def index
    authorize(Organization)
    @organizations = Organization
      .search_for(params[:q], fields: [:name], word_part: :start)
      .order("#{sorting_field || 'organizations.updated_at'} #{sorting_direction}")
      .page(params[:page])
      .per(params[:per_page] || 10)
  end

  def new
    authorize(Organization)
    @organization = Organization.new
  end

  def create
    authorize(Organization)
    @organization = Organization.new(organization_create_params)
    if @organization.save
      flash[:success] = 'Organization was successfully created'
      redirect_to organizations_path
    else
      flash[:danger] = @organization.errors.full_messages.join('')
      render 'new'
    end
  end

  def update
    authorize(@organization)
    if @organization.update(organization_update_params)
      flash[:success] = 'Organization was successfully updated'
      redirect_to profile_organization_path(@organization)
    else
      flash[:danger] = @organization.errors.full_messages.join('')
      render 'edit'
    end
  end

  def edit
    authorize(@organization)
  end

  def add_admins
    authorize(@organization)
    @users = @organization.admins.page(params[:page]).per(params[:per_page] || 5)
  end

  def add_users
    authorize(@organization)
    @users = @organization.users.page(params[:page]).per(params[:per_page] || 5)
  end

  def destroy
    authorize(@organization)
    if @organization.destroy
      flash[:success] = 'Organization was successfully destroyed'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to organizations_path
  end

  def invite
    authorize(@organization)
    @emails = params[:invites].split(',')
    new_invitation
    redirect_to add_users_to_organization_path(@organization)
  end

  def process_request
    authorize(@organization)
    @request = @organization.requests.find(params[:request_id])
    @organization.roles.create(user_id: @request.user_id) if params[:accept] == 'true'
    if @request.destroy
      flash[:success] = 'Request was successfully processed'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to @organization
  end

  def invite_from_csv
    authorize(@organization)
    @emails = []
    header = CSV.open(params[:csv].path, &:readline).first
    CSV.foreach(params[:csv].path, headers: true) do |row|
      @emails << row.to_h[header]
    end
    new_invitation
    redirect_to add_users_to_organization_path(@organization)
  end

  def show
    authorize(@organization)
    @requests = @organization.requests.includes(:user)
  end

  def profile; end

  private

  def organization_create_params
    params.require(:organization).permit(:id, :name, :sphere, :description, :avatar)
  end

  def organization_update_params
    params.require(:organization).permit(:id, :name, :sphere, :description, :avatar)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def validate_email(email)
    email.match? /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end

  def new_invitation
    errors = @emails.each_with_object("") do |email, e|
      if validate_email(email)
        if (@user = User.find_by(email: email))
          is_member = @organization.roles.find_by(user_id: @user.id)
          @organization.roles.create(user_id: @user.id) unless is_member
          UserMailer.invite(email, @organization, persisted: true).deliver_later
        else
          not_invited = @organization.invitations.where(user_email: email).empty?
          @organization.invitations.create(user_email: email) if not_invited
          UserMailer.invite(email, @organization, persisted: false).deliver_later
        end
      else
        e << "#{email} is not an email"
      end
    end
    flash[:danger] = errors unless errors.blank?
  end

  def sorting_field
    case params[:sort]
    when 'id'
      'organizations.id'
    when 'name'
      'organizations.name'
    else
      nil
    end
  end

  def sorting_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
