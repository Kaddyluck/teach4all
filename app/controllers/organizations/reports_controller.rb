class Organizations::ReportsController < ApplicationController
  def index
    @organization = Organization.find(params[:organization_id])
    authorize(@organization, :index_reports?)
    @chart = Organization.chart(@organization)
    @courses = @organization.courses.order("#{sorting_column} #{sorting_direction}")
                                    .page(params[:page])
                                    .per(20)
  end

  private

  def sorting_column
    sort_params = %w[
      created_at
      name
      passing_by_organization_users_percent
      finished_successfully_count
      finished_unsuccessfully_count
      average_rating
    ]
    if sort_params.include?(params[:sort])
      params[:sort]
    else
      'created_at'
    end
  end

  def sorting_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end