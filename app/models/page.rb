class Page < ApplicationRecord
  belongs_to :course
  has_many :questions, dependent: :destroy, index_errors: true

  accepts_nested_attributes_for :questions

  validates :title, presence: true, if: -> { course.validate? }
  validate :presence_of_content_or_questions, if: -> { course.validate? }
  validates_associated :questions, if: -> { course.validate? }

  def presence_of_content_or_questions
    if !(content? || questions?)
      errors.add(:base, "Each page should have content or some questions.")
    end
  end

  def content?
    content_hash = JSON.parse(content)
    !(content_hash["blocks"].length == 1 && content_hash["blocks"][0]["text"] == "")
  end

  def questions?
    questions.length.positive?
  end
end
