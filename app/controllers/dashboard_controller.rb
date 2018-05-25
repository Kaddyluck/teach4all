class DashboardController < ApplicationController
  def index
    @current_courses = current_user.current_courses
                                   .includes(:user, :organization)
                                   .order('passing_courses.updated_at DESC')
                                   .limit(6)
    @courses_from_organizations = policy_scope(Course).published.from_organizations
                                                      .not_touched_by_user(current_user)
                                                      .includes(:organization)
                                                      .order('courses.updated_at DESC')
                                                      .limit(6)
    @courses_from_users = policy_scope(Course).published.from_users
                                              .not_touched_by_user(current_user)
                                              .order('courses.updated_at DESC')
                                              .includes(:user, :organization)
                                              .limit(6)
    @starred_courses = current_user.favorite_courses
                                   .includes(:user, :organization)
                                   .order('favorites.created_at DESC')
                                   .limit(6)
    @passed_courses = current_user.passed_courses
                                  .includes(:user, :organization)
                                  .order('passing_courses.updated_at DESC')
                                  .limit(6)
    @recommended_courses = policy_scope(Course).published
                                               .not_touched_by_user(current_user)
                                               .includes(:user, :organization)
                                               .order('courses.average_rating DESC')
                                               .limit(6)
  end
end
