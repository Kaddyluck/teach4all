class CreateSelectedCourseUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :selected_course_users do |t|
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
