class Role < ApplicationRecord
  enum role: { default: 0, org_admin: 1, admin: 2 }
  belongs_to :organization, optional: true
  belongs_to :user
end
