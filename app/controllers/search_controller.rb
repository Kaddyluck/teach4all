class SearchController < ApplicationController
  def index
    @all_results = Course.search_for(params[:query], fields: [:name])
    @results = policy_scope(@all_results)
      .published
      .includes(:organization, :user)
      .page(params[:page])
      .per(10)
  end
end
