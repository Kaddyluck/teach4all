class ChangeCoursesPublishedToStatus < ActiveRecord::Migration[5.1]
  def change
    remove_column :courses, :published
    add_column :courses, :status, :integer, default: 0
  end
end
