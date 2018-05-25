class Organizations::CoursesController < ApplicationController
  def index
    @organization = Organization.find(params[:organization_id])
    authorize(@organization, :index_courses?)
    @courses = @organization.courses
      .db_search(params[:q])
      .includes(:user)
      .order("#{sorting_field || 'courses.updated_at'} #{sorting_direction}")
      .page(params[:page])
      .per(10)
  end

  private

  def sorting_field
    sorting_fields_map[params[:sort]]
  end

  def sorting_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sorting_fields_map
    @sorting_fields_map ||= {
      'name' => 'courses.name',
      'user' => 'users.nickname',
      'status' => 'courses.status',
      'visibility' => 'courses.visibility',
      'created_at' => 'courses.created_at',
      'updated_at' => 'courses.updated_at',
      'average_rating' => 'courses.average_rating'
    }
  end
end
