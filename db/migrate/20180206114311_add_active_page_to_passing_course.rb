class AddActivePageToPassingCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :passing_courses, :active_page, :integer, default: 0
  end
end
