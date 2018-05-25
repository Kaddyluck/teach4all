class CoursePolicy < ApplicationPolicy
  def show?
    return false unless @record.published?
    if @record.visibility == 'for_all_users'
      true
    elsif @record.visibility == 'for_organization_users'
      @user.organizations.include?(@record.organization) || @user.admin?
    elsif @record.visibility == 'for_selected_users'
      @record.selected_course_users.map(&:user_id).include?(@user.id) || @record.user == @user
    else
      false
    end
  end

  def edit?
    if @record.organization
      @user == @record.user || @record.organization.org_admin?(@user.id) || @user.admin?
    else
      @user == @record.user || @user.admin?
    end
  end

  def update?
    edit?
  end

  def validate_and_save?
    edit?
  end

  def publish?
    edit?
  end

  class Scope < Scope
    def resolve
      user_organization_ids = @user.organizations.pluck(:id)

      scope.left_joins(:selected_course_users)
        .where(<<-SQL, user_organization_ids, @user.id)
          courses.visibility = 0
          OR (courses.visibility = 1 AND courses.organization_id IN (?))
          OR (courses.visibility = 2 AND selected_course_users.user_id = ?)
        SQL
        .distinct
    end
  end
end
