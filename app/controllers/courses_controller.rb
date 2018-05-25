class CoursesController < ApplicationController
  def new
  end

  def create
    @course = current_user.courses.create(get_course_attributes)
    render json: {redirect: edit_course_path(@course)}
  end

  def edit
    @course = Course.includes([pages: [questions: [:answers]]]).find(params[:id])
    authorize(@course)
    @pages = @course.pages.map do |p|
      {
        title: p.title,
        content: p.content,
        questions: p.questions.map do |q|
          {
            text: q.text,
            type: q.question_type,
            answers: q.answers.map do |a|
              {
                text: a.text,
                correct: a.correct
              }
            end
          }
        end
      }
    end
  end

  def update
    @course = Course.find(params[:id])
    authorize(@course)
    Course.transaction do
      @course.pages.destroy_all
      if @course.update(get_course_attributes)
        render json: { alertMessage: "Successfully saved to server!", alertColor: "success" }
      else
        render json:
        {
          alertMessage: "Looks like course is published and it can't be update due to error: " + @course.first_error_text,
          alertColor: "danger" 
        }
        raise ActiveRecord::Rollback
      end
    end
  end

  def validate_and_save
    @course = Course.find(params[:id])
    authorize(@course)
    Course.transaction do
      @course.pages.destroy_all
      @course.update(status: :validated)
      if @course.update(get_course_attributes)
        render json: { redirect: publish_page_course_path }
      else
        render json:
        {
          alertMessage: "Can't publish course due to error: " + @course.first_error_text, 
          alertColor: "danger" 
        }
        raise ActiveRecord::Rollback
      end
    end
  end

  def publish_page
    @course = Course.find(params[:id])
    @user_orgs = current_user.organizations
    @selected_course_users = User.none
  end

  def publish
    @course = Course.find(params[:id])
    authorize(@course)
    if params[:course][:organization_id].present?
      @course.organization_id = params[:course][:organization_id]
    else
      @course.organization_id = nil
    end
    @course.visibility = params[:course][:visibility].to_i
    @course.status = :published
    if params[:course][:selected_course_user_ids]
      params[:course][:selected_course_user_ids].each do |id|
        @course.selected_course_users.new(user_id: id)
      end
    end
    if params[:course][:avatar]
      @course.avatar = params[:course][:avatar]
    end

    if @course.save
      redirect_to new_course_certificate_template_path(@course), notice: 'Course published!'
    else
      redirect_to publish_page_course_path, alert: @course.first_error_text
    end
  end

  def show
    @course = Course.includes(:user, :pages).find(params[:id])
    authorize(@course)
    @passing_course = current_user.passing_courses.find_by(course_id: @course.id)
    @user_rating = current_user.ratings.find_by(course_id: @course.id)
    @user_rating = @user_rating ? @user_rating.value : 0
    @favorite = current_user.favorites.find_by(course_id: @course.id)
  end

  private

  def course_params
    params.require(:course)
          .permit(:name, :published, :avatar, pages: [:title, :content, questions: [:type, :text, answers: [:text, :correct]]])
  end

  def get_course_attributes
    course_params_hash = course_params.to_h
    course_attributes = {
      name: course_params_hash[:name],
      pages_attributes: pages_attributes(course_params_hash[:pages])
    }
  end

  def pages_attributes(pages_hash)
    if pages_hash
      pages_hash.values.map do |page|
        {
          title: page[:title],
          content: page[:content],
          questions_attributes: question_attributes(page[:questions])
        }
      end 
    else
      []
    end
  end

  def question_attributes(questions_hash)
    if questions_hash
      questions_hash.values.map do |question|
        {
          question_type: question[:type],
          text: question[:text],
          answers_attributes: answers_attributes(question[:answers])
        }
      end
    else
      []
    end
  end

  def answers_attributes(answers_hash)
    if answers_hash
      answers_hash.values
    else
      []
    end
  end
end
