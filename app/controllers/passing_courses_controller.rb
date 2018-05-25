class PassingCoursesController < ApplicationController
  def show
    @course = Course.includes([pages: [questions: [:answers]]]).find(params[:id])
    authorize(@course, :show?)
    @passing_course = current_user.passing_courses.includes([:user_answers]).find_or_create_by(course_id: @course.id)
    if @passing_course.need_restart?
      @passing_course.restart
      flash.now[:notice] = 'Sorry, your progress has been reset since the author updated the course.'
    end
    if params[:restart] == 'true'
      @passing_course.restart
      flash.now[:notice] = 'Restart course. Your previous answers was destoyed.'
    end

    @pages = @pages = @course.pages.map do |p|
      {
        title: p.title,
        content: p.content,
        questions: p.questions.map do |q|
          {
            id: q.id,
            text: q.text,
            type: q.question_type,
            answers: q.answers.map do |a|
              {
                id: a.id,
                text: a.text
              }
            end
          }
        end
      }
    end

    @user_answers = @passing_course.user_answers.map do |a|
      {
        question_id: a.question_id,
        answer_id: a.answer_id,
        text: a.text
      }
    end
    @user_answers = @user_answers.map { |user_answer| user_answer.deep_transform_keys! { |key| key.to_s.camelize(:lower) } }
  end

  def save_progress
    @passing_course = current_user.passing_courses.find_by(course_id: user_answers_params[:id])
    @passing_course.transaction do
      @passing_course.user_answers.destroy_all
      if @passing_course.update(get_user_answers_attributes)
        head :no_content
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  def check_answers
    @passing_course = current_user.passing_courses.find_by(course_id: params[:id])
    @passing_course.check_answers
    render json: {redirect: course_path(params[:id])}
  end

  private

  def get_user_answers_attributes
    user_answers_hash = user_answers_params[:userAnswers].to_h
    {
      active_page: user_answers_params[:activePage],
      user_answers_attributes: user_answers_hash.values.map do |user_answer|
        {
          question_id: user_answer[:questionId],
          answer_id: user_answer[:answerId],
          text: user_answer[:text]
        }
      end
    }
  end

  def user_answers_params
    params.permit(:id, :activePage, userAnswers: [:questionId, :answerId, :text])
  end

end
