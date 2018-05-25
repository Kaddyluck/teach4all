module MessagesHelper
  def unread_receipt_class(receipt)
    if (receipt.box == 'inbox') && !receipt.viewed?
      'receipt-unread'
    else
      ''
    end
  end

  def messaging_user_attribute(user, attribute)
    user ? user.public_send(attribute) : '#deleted_user'
  end
end
