class Organizations::UsersController < ApplicationController
  def index
    @organization = Organization.find(params[:organization_id])
    authorize(@organization, :index_users?)
    @search_field_options = %w[- nickname email first_name last_name]
    @users = OrganizationUsers.new(@organization).search(params[:q], fields: searching_fields)
                                                 .where(registered: params[:registered])
                                                 .order(sorting_field, sorting_direction)
    @users = Kaminari.paginate_array(@users.to_a).page(params[:page]).per(20)
  end

  private

  def sorting_field
   sortable_fields.include?(params[:sort]) ? params[:sort] : 'email'
  end

  def sorting_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def searching_fields
    searchable_fields.include?(params[:search]) ? [params[:search]] : nil
  end

  def sortable_fields
    OrganizationUsers::ORDERABLE_FIELDS.map(&:to_s)
  end

  def searchable_fields
    OrganizationUsers::SEARCHABLE_FIELDS.map(&:to_s)
  end
end
