class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.references :page, foreign_key: true
      t.string :type
      t.text :text

      t.timestamps
    end
  end
end
