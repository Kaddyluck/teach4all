class Users::CertificatesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    authorize(@user, :index_certificates?)
    @certificates = @user.certificates
      .search_by_course_name(params[:q])
      .includes(course: [:organization, :user])
      .order("#{sorting_field || 'certificates.created_at'} #{sorting_direction}")
      .page(params[:page])
      .per(6)
  end

  private

  def sorting_field
    sorting_fields_map[params[:sort]]
  end

  def sorting_fields_map
    @sorting_fields_map =
      {
        'course' => 'courses.name',
        'organization' => 'organizations.name',
        'author' => 'users.name',
        'received_at' => 'certificates.created_at'
      }
  end

  def sorting_direction
    %w[asc decs].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
