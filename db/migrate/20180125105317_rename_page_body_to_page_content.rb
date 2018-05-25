class RenamePageBodyToPageContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :pages, :body, :content
  end
end
