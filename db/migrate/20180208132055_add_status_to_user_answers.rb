class AddStatusToUserAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :user_answers, :status, :integer, default: 0
  end
end
