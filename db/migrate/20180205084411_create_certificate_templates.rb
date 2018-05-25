class CreateCertificateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :certificate_templates do |t|
      t.string :filename
      t.references :owner, polymorphic:true, index:true

      t.timestamps
    end
  end
end
