class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :course
  validates_presence_of :course, :user
  validates_inclusion_of :value, in: -10..10

  after_save :update_average_rating

  def update_average_rating
    course.recalculate_rating
  end
end
