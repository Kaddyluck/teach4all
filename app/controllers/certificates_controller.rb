class CertificatesController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @certificate = @course.certificates.find_by(user_id: params[:user_id])
    send_file @certificate.pdf.path,
    filename: @certificate.pdf_file_name,
    disposition: "inline",
    type: "application/pdf"
  end
end
