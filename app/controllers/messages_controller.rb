class MessagesController < ApplicationController
  before_action :set_box, only: :index
  before_action :set_receipt, only: [:show, :destroy, :restore]
  before_action :read_receipt, only: :show
  before_action :set_unread_receipts_count, except: [:destroy, :restore]

  def index
    @receipts = case @box
    when 'inbox'
      Receipt.inbox_for(current_user).includes(:message, message: :sender)
    when 'sentbox'
      Receipt.sentbox_for(current_user).includes(:message, message: :receiver)
    when 'trashbox'
      Receipt.trashbox_for(current_user).includes(:message, message: [:sender, :receiver])
    end
    @receipts = @receipts.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    authorize(@receipt)
    if @receipt.box == 'inbox'
      receiver_ids = @receipt.message.sender ? [@receipt.message.sender.id] : nil
      @message_sending = MessageSending.new(receiver_ids: receiver_ids)
    end
  end

  def new
    @message_sending = MessageSending.new
    @selected_receivers = User.none
  end

  def create
    @message_sending = MessageSending.new(message_sending_params)
    if @message_sending.perform
      flash[:success] = "Message sent"
      redirect_to messages_url(box: 'sentbox')
    else
      @selected_receivers = User.where(id: message_sending_params[:receiver_ids]).order(:nickname)
      render 'new'
    end
  end

  def destroy
    authorize(@receipt)
    @receipt.move_to_trash
    flash[:info] = "Message moved to trash"
    redirect_to messages_url(box: @receipt.box)
  end

  def restore
    authorize(@receipt)
    @receipt.restore
    flash[:info] = "Message restored"
    redirect_to messages_url(box: 'trashbox')
  end

  def empty_trash
    Receipt.trashbox_for(current_user).destroy_all
    flash[:info] = "Trashbox emptied"
    redirect_to messages_path(box: 'trashbox')
  end

  private

  def set_unread_receipts_count
    @unread_receipts_count = Receipt.inbox_for(current_user).where(viewed: false).count
  end

  def set_box
    if ['inbox', 'sentbox', 'trashbox'].include?(params[:box])
      @box = params[:box]
    else
      @box = 'inbox'
    end
  end

  def read_receipt
    @receipt.update(viewed: true)
  end

  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  def message_sending_params
    params.require(:message_sending).permit(:body, receiver_ids: []).merge(sender_id: current_user.id)
  end
end
