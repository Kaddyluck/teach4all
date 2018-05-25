class CreatePassingCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :passing_courses do |t|
      t.references :course, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :result

      t.timestamps
    end
  end
end
