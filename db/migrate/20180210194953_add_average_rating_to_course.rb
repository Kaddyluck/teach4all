class AddAverageRatingToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :average_rating, :float, default: 0
  end
end
