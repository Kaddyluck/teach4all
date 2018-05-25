class Dashboard::CoursesController < ApplicationController
  def current
    @current_courses = current_user
      .current_courses
      .db_search(params[:q])
      .includes(:user, :organization)
      .order("#{sorting_field || 'passing_courses.updated_at'} #{sorting_direction}")
      .page(params[:page])
      .per(10)
  end

  def from_organizations
    @courses_from_organizations = policy_scope(Course)
      .published
      .from_organizations
      .not_touched_by_user(current_user)
      .db_search(params[:q])
      .includes(:organization)
      .order("#{sorting_field || 'courses.updated_at'} #{sorting_direction}")
      .page(params[:page])
      .per(10)
  end

  def from_users
    @courses_from_users = policy_scope(Course)
      .published
      .from_users
      .not_touched_by_user(current_user)
      .db_search(params[:q])
      .includes(:user)
      .order("#{sorting_field || 'courses.updated_at'} #{sorting_direction}")
      .page(params[:page])
      .per(10)
  end

  def starred
    @starred_courses = current_user
      .favorite_courses
      .db_search(params[:q])
      .includes(:user, :organization)
      .order("#{sorting_field || 'favorites.created_at'} #{sorting_direction}")
      .page(params[:page])
      .per(10)
  end

  def passed
    @passed_courses = current_user
      .passed_courses
      .db_search(params[:q])
      .includes(:user, :organization, :ratings)
      .order("#{sorting_field || 'passing_courses.updated_at'} #{sorting_direction}")
      .page(params[:page])
      .per(10)
  end

  def recommended
    @recommended_courses = policy_scope(Course)
      .published
      .not_touched_by_user(current_user)
      .db_search(params[:q])
      .includes(:user, :organization)
      .order("#{sorting_field || 'courses.average_rating'} #{sorting_direction}")
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
      'organization' => 'organizations.name',
      'progress' => 'passing_courses.progress',
      'updated_at' => 'courses.updated_at',
      'starred_at' => 'favorites.created_at',
      'average_rating' => 'courses.average_rating',
      'rating' => 'ratings.value',
      'passed_at' => 'passing_courses.updated_at'
    }
  end
end
