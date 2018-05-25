class RenameTypeToQuestionType < ActiveRecord::Migration[5.1]
  def change
    rename_column :questions, :type, :question_type
  end
end
