class AddReferencesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :organization, foreign_key: true, index:true
  end
end
