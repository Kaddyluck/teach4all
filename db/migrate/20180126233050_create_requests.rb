class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true, index: true
      t.references :organization, foreign_key: true, index: true

      t.timestamps
    end
  end
end
