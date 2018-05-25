class MessageSending
  include ActiveModel::Model

  validates :sender_id, presence: true
  validates :receiver_ids, presence: true
  validate :receiver_is_not_sender
  validates :body, presence: true,
                   length: { maximum: 3000 }

  attr_accessor :sender_id, :receiver_ids, :body

  def initialize(attributes={})
    attributes = convert_attributes(attributes)
    super
  end

  def perform
    @sender = User.find(sender_id)
    @receivers = User.where(id: receiver_ids)
    if valid?
      Message.transaction do
        @receivers.each do |receiver|
          msg = Message.new(body: body)
          msg.dispatch(from: @sender,
                       to: receiver)
          send_notification_to(receiver)
        end
      end
      true
    else
      false
    end
  end

  private

  def convert_attributes(attributes)
    converted_sender_id = attributes[:sender_id] ? attributes[:sender_id].to_i : nil
    converted_receiver_ids = attributes[:receiver_ids] ? attributes[:receiver_ids].map(&:to_i) : {}
    attributes.merge(sender_id: converted_sender_id,
                     receiver_ids: converted_receiver_ids)
  end

  def send_notification_to(receiver)
    MessagesChannel.broadcast_to receiver,
                                 sender: @sender.nickname,
                                 body: body
  end

  def receiver_is_not_sender
    return unless receiver_ids.include?(sender_id)
    errors.add(:base, "You cannot send message to yourself")
  end
end
