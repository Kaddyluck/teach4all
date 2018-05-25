class CreateUserAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :user_answers do |t|
      t.references :passing_course, foreign_key: true
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
