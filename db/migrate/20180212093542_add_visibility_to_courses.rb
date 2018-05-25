class AddVisibilityToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :visibility, :integer, default: 0
  end
end
