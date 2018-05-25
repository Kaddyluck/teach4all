class RolePolicy < ApplicationPolicy
  def new?
    @organization = @record.organization
    if @organization
      @organization.org_admin?(@user.id) || @user.admin?
    else
      @user.admin?
    end
  end

  def create?
    new?
  end

  def update?
    new?
  end

  def destroy?
    new?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
