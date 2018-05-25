class CertificateTemplatesController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    @template = @course.build_certificate_template
    @user_templates = current_user.certificate_templates
    @user_templates += @course.organization.certificate_templates if @course.organization
  end

  def create
    @course = Course.find(params[:course_id])
    if params[:certificate_template]
      if @course.organization.nil?
        @template = @course.user.certificate_templates.new(template_params)
      else
        @template = @course.organization.certificate_templates.new(template_params)
      end
      if (fields = @template.check_template_fields).empty?
        @template.save
        @template.courses << @course
        redirect_to @course, notice: 'Template was successfully added'
      else
        flash[:danger] = 'Pdf does not include required fields: ' + fields.join(', ')
        redirect_to new_course_certificate_template_path(@course)
      end
    else
      flash[:danger] = 'No file attached.'
      redirect_to new_course_certificate_template_path(@course)
    end
  end

  def attach
    @course = Course.find(params[:course_id])
    @template = CertificateTemplate.find(params[:id])
    @template.courses << @course
    redirect_to @course, notice:"Template was succesfully attached"
  end

  def destroy
    @course = Course.find(params[:course_id])
    @template = CertificateTemplate.find(params[:id])
    @template.destroy
    redirect_to new_course_certificate_template_path(@course)
  end

  private

  def template_params
    params.require(:certificate_template).permit(:pdf)
  end
end
