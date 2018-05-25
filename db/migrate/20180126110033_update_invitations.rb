class UpdateInvitations < ActiveRecord::Migration[5.1]
  def change
    change_column :invitations, :user_persisted, :boolean, default: false
    change_column :invitations, :accepted, :boolean, default: false
  end
end
