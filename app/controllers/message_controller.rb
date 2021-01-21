class MessageController < ApplicationController
  def create
    # byebug
    @front_end_message=create_message_params
    # send body and user1 to :message_body and :creator_id in :messages
    # for now set parent_id to 0
    @user2=User.where(username: create_message_params[:user2])
    @message=Message.new(creator_id: @front_end_message[:user1], message_body: @front_end_message[:body], parent_id: 0)
    if !@message.save
      return render json: {status: "error", message: "fail while saving to Message"}
    end
    # find & send message_id; send user2 to :message_recipient; set is_read to false
    @message_recipient=MessageRecipient.new(recipient_id: @user2.ids[0], message_id: @message.id, is_read: false)
    # byebug
    if !@message_recipient.save
      return render json: {status: "error", message: "fail while saving to MessageRecipient"}
    end
    render json: {message: @message, message_recipient: @message_recipient}, status: :created
  end

  def index
    # byebug
    # .... riiiiiight.  Get the messages from Message where recipient_id = user_id.  
    # .... maybe it's time to get global props somehow?  
    #get the message_id's from message_recipients
    #where recipient_id = user
    @message_ids=MessageRecipient.where( recipient_id: retrieve_message_params[:userId] )
    # User.find(retrieve_message_params[:userId])
    #for each message_id, add the message
    # @message_ids.map{|mid| mid["message_id"]}
    @messages=Message.where(id: @message_ids.map{|mid| mid["message_id"]})
    
    render json: {messages: @messages}
  end

  private

  def create_message_params
    params.require(:message).permit(:body, :user1, :user2)
  end

  def retrieve_message_params
    params.require(:user).permit(:userId)
  end

end
