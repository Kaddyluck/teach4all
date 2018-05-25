class AddStatisticToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :passing_courses_count, :integer, default: 0
    add_column :courses, :finished_successfully_count, :integer, default: 0
    add_column :courses, :finished_unsuccessfully_count, :integer, default: 0
    add_column :courses, :passing_by_organization_users_percent, :integer, default: 0
  end
end
