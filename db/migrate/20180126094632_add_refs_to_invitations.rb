class AddRefsToInvitations < ActiveRecord::Migration[5.1]
  def change
    add_reference :invitations, :organization, foreign_key: true, index:true
  end
end
