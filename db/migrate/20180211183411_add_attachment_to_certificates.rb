class AddAttachmentToCertificates < ActiveRecord::Migration[5.1]
  def self.up
    change_table :certificates do |t|
      t.attachment :pdf
    end
  end
  
  def self.down
    remove_attachment :certificates, :pdf
  end
end
