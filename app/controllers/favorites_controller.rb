class FavoritesController < ApplicationController
  def add_to_favorites
    current_user.favorites.find_or_create_by(course_id: params[:id])
    redirect_to course_path
  end

  def remove_from_favorites
    current_user.favorites.find_by(course_id: params[:id]).destroy
    redirect_to course_path
  end
end