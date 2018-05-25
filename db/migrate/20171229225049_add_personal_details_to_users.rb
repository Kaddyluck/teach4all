class AddPersonalDetailsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nickname, :string, null: false, default: ""
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    add_index :users, :nickname, unique: true
  end
end
