class CreateImpersonations < ActiveRecord::Migration[5.1]
  def change
    create_table :impersonations do |t|
      t.references :impersonator
      t.references :target_user
      t.timestamp :ended_at

      t.timestamps
    end
  end
end
