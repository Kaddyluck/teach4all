class CreateReviewRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :review_requests do |t|
      t.references :user, foreign_key: true
      t.references :user_answer, foreign_key: true

      t.timestamps
    end
  end
end
