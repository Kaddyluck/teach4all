class Certificate < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_attached_file :pdf, styles: {icon: ["200x200>", :jpg]},
                          convert_options: { :all => '-background white -flatten +matte'}
  validates_attachment :pdf, presence: true,
                             content_type: { content_type: "application/pdf" }
  before_post_process :skip_on_create
  after_create :create_styles

  def self.search_by_course_name(course_name)
    return self.all if course_name.blank?
    words = course_name.split
    words.reduce(self.joins(:course)) do |relation, word|
      relation.where("courses.name ILIKE ?", "%#{word}%")
    end
  end

  def skip_on_create
    !new_record?
  end

  def create_styles
    pdf.reprocess!
  end

  def fill_out
    if course.certificate_template_id.nil?
      template = "#{Rails.root}/pdfs/base_template.pdf"
      self.pdf = File.open(template)
    else
      template = course.certificate_template.pdf.path
      self.pdf = course.certificate_template.pdf
    end
    fields = { username: user.first_name + ' ' + user.last_name,
               course: course.name,
               author: course.organization ? course.organization.name : course.user.nickname,
               date: Time.now.strftime('%Y/%d/%m') }
    pdftk.fill_form template, pdf.queued_for_write[:original].path, fields, flatten: true
  end

  private

  def pdftk
    @pdftk ||= PdfForms.new(ENV['PDFTK_PATH'] || '/usr/local/bin/pdftk')
    # mine is '/usr/bin/pdftk'
  end
end
