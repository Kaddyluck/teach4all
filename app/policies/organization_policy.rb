class OrganizationPolicy < ApplicationPolicy
  def index?
    @user.admin?
  end

  def show?
    @record.org_admin?(@user.id)
  end

  def new?
    @user.admin?
  end

  def create?
    @user.admin?
  end

  def edit?
    @record.org_admin?(@user.id) || @user.admin?
  end

  def update?
    @record.org_admin?(@user.id) || @user.admin?
  end

  def destroy?
    @user.admin?
  end

  def add_admins?
    @user.admin?
  end

  def add_users?
    @record.org_admin?(@user.id)
  end

  def index_users?
    @record.org_admin?(@user.id)
  end

  def index_courses?
    @record.org_admin?(@user.id)
  end

  def invite?
    @record.org_admin?(@user.id)
  end

  def invite_from_csv?
    @record.org_admin?(@user.id)
  end

  def process_request?
    @record.org_admin?(@user.id)
  end

  def index_impersonations?
    @record.org_admin?(@user.id)
  end

  def index_reports?
    @record.org_admin?(@user.id)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
