class Receipt < ApplicationRecord
  belongs_to :message
  belongs_to :owner, class_name: User.name

  delegate :sender, :receiver, to: :message

  scope :inbox_for, ->(user) { where(owner: user, box: 'inbox', trashed: false) }
  scope :sentbox_for, ->(user) { where(owner: user, box: 'sentbox', trashed: false) }
  scope :trashbox_for, ->(user) { where(owner: user, trashed: true ) }

  def move_to_trash
    self.update(trashed: true)
  end

  def restore
    self.update(trashed: false)
  end
end
