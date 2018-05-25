class UserPolicy < ApplicationPolicy
  def impersonate?
    return false if @record.admin?
    organizations = @record.organizations
    return false if organizations.blank?
    return false if organizations.select { |organization| organization.org_admin?(@user.id) }.blank?
    return false if organizations.select { |organization| organization.org_admin?(@record.id) }.present?
    true
  end

  def stop_impersonation?
    impersonate?
  end

  def index_courses?
    @record == @user
  end

  def index_certificates?
    @record == @user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
