class AddRefsToRoles < ActiveRecord::Migration[5.1]
  def change
    add_reference :roles, :organization, foreign_key: true, index: true
    add_reference :roles, :user, foreign_key: true, index: true
  end
end
