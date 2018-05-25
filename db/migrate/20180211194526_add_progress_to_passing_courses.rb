class AddProgressToPassingCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :passing_courses, :progress, :decimal, precision: 5, scale: 2
  end
end
