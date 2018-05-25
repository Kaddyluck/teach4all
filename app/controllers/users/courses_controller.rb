class Users::CoursesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    authorize(@user, :index_courses?)
    @courses = @user.courses
                    .db_search(params[:q])
                    .includes(:organization)
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
      'organization' => 'organizations.name',
      'status' => 'courses.status',
      'updated_at' => 'courses.updated_at'
    }
  end
end
