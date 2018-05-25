class Organizations::ImpersonationsController < ApplicationController
  def index
    @organization = Organization.find(params[:organization_id])
    authorize(@organization, :index_impersonations?)
    @impersonations = @organization.impersonations.includes(:target_user, :impersonator)
                                   .db_search(params[:q], fields: searching_fields, word_part: :start)
                                   .where(created_at: date_range(:created_at), ended_at: date_range(:ended_at))
                                   .order("#{sorting_column} #{sorting_direction}")
                                   .page(params[:page])
                                   .per(20)
    @search_field_options = %w[- target_user_nickname impersonator_nickname]
  end

  private

  def sorting_column
    if %w[created_at ended_at].include?(params[:sort])
      "impersonations.#{params[:sort]}"
    elsif params[:sort] == 'target_user'
      'target_users_impersonations.nickname'
    elsif params[:sort] == 'impersonator'
      'impersonators_impersonations.nickname'
    else
      'ended_at'
    end
  end

  def sorting_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def date_range(field)
    beginning =
      if params[:"#{field}_beginning"].present?
        Time.zone.parse(params[:"#{field}_beginning"])
      else
        1000.years.ago
      end
    ending =
      if params[:"#{field}_ending"].present?
        Time.zone.parse(params[:"#{field}_ending"]).at_end_of_day
      else
        Time.zone.now
      end
    beginning..ending
  end

  def searching_fields
    %w[target_user_nickname impersonator_nickname].include?(params[:search]) ? [params[:search]] : nil
  end
end
