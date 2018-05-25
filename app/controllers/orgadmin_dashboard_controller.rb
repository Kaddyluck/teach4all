class OrgadminDashboardController < ApplicationController
  def index
    @organizations = current_user.organizations.order(:name)
      .select { |organization| organization.org_admin?(current_user.id) }
  end
end
