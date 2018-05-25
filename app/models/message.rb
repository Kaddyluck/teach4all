class Message < ApplicationRecord
  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name
  has_many :receipts, dependent: :destroy

  def dispatch(from: self.sender, to: self.receiver)
    self.sender = from
    self.receiver = to
    self.receipts = [Receipt.new(owner: self.sender, box: 'sentbox'),
                     Receipt.new(owner: self.receiver, box: 'inbox')]
    self.save!
  end
end
