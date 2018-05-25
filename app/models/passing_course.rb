# frozen_string_literal: true

class PassingCourse < ApplicationRecord
  enum status: %i[passing reviewing finished_successfully finished_unsuccessfully need_restart]

  belongs_to :course
  belongs_to :user
  has_many :user_answers

  accepts_nested_attributes_for :user_answers

  validates :progress, inclusion: { in: (0.0..100.0) }

  before_validation :calculate_progress
  after_create :recalculate_course_statistics
  after_update :recalculate_course_statistics, if: :saved_change_to_status?

  def check_answers
    update(status: :reviewing)
    user_answers.group_by(&:question_id).each do |question_id, answers|
      question = Question.find(question_id)
      if %w[checkbox radio select].include? question.question_type
        if question.predefined_answers_correct?(answers)
          answers.each { |a| a.update(status: :correct) }
        else
          answers.each { |a| a.update(status: :uncorrect) }
        end
      else
        ReviewRequest.create(user_id: question.page.course.user.id, user_answer_id: answers[0].id)
      end
    end
    set_result
  end

  def set_result
    unless user_answers.any?(&:need_review?)
      correct_answered_questions = 0
      user_answers.group_by(&:question_id).each_value do |answers|
        correct_answered_questions += 1 if answers.all?(&:correct?)
      end
      questions_count = 0
      course.pages.includes(:questions).each do |page|
        questions_count += page.questions.length
      end
      begin
        result = (correct_answered_questions.to_f / questions_count * 100).round
      rescue FloatDomainError
        result = 100
      end
      status = result >= 90 ? :finished_successfully : :finished_unsuccessfully
      update(result: result, status: status)
      sign_certificate if result >= 90 && no_certificate?
    end
  end

  def sign_certificate
    @certificate = User.find(user_id).certificates.build(course_id: course_id)
    @certificate.fill_out
    @certificate.save
  end

  def recalculate_course_statistics
    course.recalculate_statistics
  end

  def restart
    user_answers.destroy_all
    update(status: :passing, active_page: 0)
  end

  private

  def calculate_progress
    self.progress = (active_page.to_f / course.pages.count) * 100
  end

  def no_certificate?
    user.certificates.where(course_id: course_id).empty?
  end
end
