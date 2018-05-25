class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.string :user_email
      t.boolean :user_persisted
      t.boolean :accepted

      t.timestamps
    end
  end
end
