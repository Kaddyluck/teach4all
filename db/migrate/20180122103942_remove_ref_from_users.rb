class RemoveRefFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :users, :organization,index: true, foreign_key: true
  end
end
