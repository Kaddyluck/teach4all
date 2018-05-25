class CreateReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :receipts do |t|
      t.references :message
      t.references :owner
      t.string :box
      t.boolean :viewed, default: false
      t.boolean :trashed, default: false

      t.timestamps
    end
  end
end
