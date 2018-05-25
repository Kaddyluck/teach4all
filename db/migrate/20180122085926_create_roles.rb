class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.integer :role, null:false, default:0
      t.timestamps
    end
  end
end
