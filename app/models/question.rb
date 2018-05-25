# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :page
  has_many :answers, dependent: :destroy, index_errors: true
  has_many :user_answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  validates :text, presence: true, if: -> { page.course.validate? }
  validates :answers, presence: true, if: -> { %w[textarea textfield].exclude?(question_type) }
  validates_associated :answers, if: -> { page.course.validate? }

  def predefined_answers_correct?(users_answers)
    answers.correct.map(&:id).sort == users_answers.map(&:answer_id).sort
  end
end
