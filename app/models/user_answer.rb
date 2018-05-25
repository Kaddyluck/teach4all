class UserAnswer < ApplicationRecord
  enum status: [:need_review, :correct, :uncorrect]

  belongs_to :passing_course
  belongs_to :question, optional: true
  belongs_to :answer, optional: true
  has_one :review_request
end
