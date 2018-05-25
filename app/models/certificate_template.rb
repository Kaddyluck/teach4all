class CertificateTemplate < ApplicationRecord
  has_many :courses, dependent: :nullify
  belongs_to :owner, polymorphic: true
  has_attached_file :pdf, styles: {icon: ["200x200>", :jpg]},
      convert_options: { :all => '-background white -flatten +matte'}
  validates_attachment :pdf, presence: true,
                             content_type: { content_type: "application/pdf" }

  def check_template_fields
    fields = pdftk.get_field_names self.pdf.queued_for_write[:original].path
    (%w[username date author course] - fields)
  end

  private

  def pdftk
    @pdftk ||= PdfForms.new(ENV['PDFTK_PATH'] || '/usr/bin/pdftk')
    # mine is '/usr/bin/pdftk'
  end
end
