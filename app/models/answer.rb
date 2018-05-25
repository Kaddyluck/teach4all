class Answer < ApplicationRecord
  belongs_to :question, optional: true
  has_many :user_answers, dependent: :destroy

  validates :text, presence: true, if: -> { question.page.course.validate? }

  scope :correct, -> { where(correct: true) }
end

