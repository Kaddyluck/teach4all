class AddAttachmentPdfToCertificateTemplates < ActiveRecord::Migration[4.2]
  def self.up
    change_table :certificate_templates do |t|
      t.attachment :pdf
    end
  end

  def self.down
    remove_attachment :certificate_templates, :pdf
  end
end
