class Invitation < ApplicationRecord
  belongs_to :organization
  validates :user_email, presence: true
end
