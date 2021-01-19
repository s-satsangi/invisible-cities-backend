class MessageController < ApplicationController
  def create
    @front_end_message=message_params
    # send body and user1 to :message_body and :creator_id in :messages
    # for now set parent_id to 0

    @message=Message.new(creator_id: @front_end_message[:user1], message_body: @front_end_message[:body], parent_id: 0)
    if !@message.save
      return render json: {status: "error", message: "fail while saving to Message"}
    end
    # find & send message_id; send user2 to :message_recipient; set is_read to false
    @message_recipient=MessageRecipient.new(recipient_id: @front_end_message[:user2], message_id: @message.id, is_read: false)
    byebug
    if !@message_recipient.save
      return render json: {status: "error", message: "fail while saving to MessageRecipient"}
    end
    render json: {message: @message, message_recipient: @message_recipient}, status: :created
  end

  def index
    byebug
  end

  private

  def message_params
    params.require(:message).permit(:body, :user1, :user2)
  end

end
