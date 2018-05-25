class ReviewRequest < ApplicationRecord
  belongs_to :user
  belongs_to :user_answer
end
