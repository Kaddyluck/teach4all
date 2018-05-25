class RatingsController < ApplicationController
  def rate
    @rating = current_user.ratings.find_or_create_by(course_id: params[:id])
    if @rating.update(value: params[:value])
      render json: {}
    end
  end
end