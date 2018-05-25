class AutocompleteController < ApplicationController
  skip_before_action :authenticate_user!, only: :organizations

  def users
    if query
      @results = User.search_for(query, exclude: current_user, limit: 4)
    else
      @results = current_user.interlocutors.take(10)
    end
    render json: { results: @results }
  end

  def organizations
    @results = Organization.search_for(query, fields: [:name], word_part: :start)
      .order(:name)
      .limit(3)
  end

  def users_to_organization
    @organization = Organization.find(params[:organization_id])
    @results = User.where.not(id: @organization.user_ids)
      .db_search(query, fields: [:nickname], word_part: :start)
      .order(:nickname)
      .limit(3)
  end

  def users_to_orgadmins
    @organization = Organization.find(params[:organization_id])
    @results = User.where.not(id: @organization.admins.ids)
      .db_search(query, fields: [:nickname], word_part: :start)
      .order(:nickname)
      .limit(3)
  end

  private

  def query
    @query ||= params[:q].present? ? params[:q] : nil
  end
end
