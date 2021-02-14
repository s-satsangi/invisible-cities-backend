class MessageController < ApplicationController

  #endpoint to create a message

  #insert message & creator_id (from cookie) 
  #   in messages
  #insert message_id, group_id, recipient_id 
  #  (zero if multi-user)
  #  into message_recipients 
  def create
    #check if params came with user_groups.
    #  if params recipient = 0, then multi = []  
    #if no user_groups, make new entries
    
    # send body and user1 to :message_body and :creator_id in :messages
    # for now set parent_id to 0
    # byebug
    user1 = User.find(decode_jwt(cookies.signed[:jwt])["user_id"])
    # byebug
    user2=UserGroup.where(group_id: message_params[:user_groups]).pluck(:user_id)
    message=Message.new(creator_id: user1.id, message_body: message_params[:message_body], parent_id: message_params[:parent_id])
    if !message.save
      return render json: {status: "error", message: "fail while saving to Message"}
    end
    # find & send message_id; send user2 to :message_recipient; set is_read to false
    user2.each do |recip|
    message_recipient=MessageRecipient.new(recipient_id: recip, recipient_group_id: message_params[:user_groups], message_id: message.id, is_read: false)
    # byebug
    if !message_recipient.save
      return render json: {status: "error", message: "fail while saving to MessageRecipient with user_id: " + recip}
    end

  end
    # I could return message recipients here, too, but why?  why return message?
    render json: {message: message}, status: :created
  end

  #endpoint to mark when a user has read messages
  #in a convo
  def read_messages
  end
  
  # endpoint to return all user's messages 
  #   sorted by group_id
  def index
    # byebug
    # .... riiiiiight.  Get the messages from Message where recipient_id = user_id.  
    # .... maybe it's time to get global props somehow?  
    #get the message_id's from message_recipients
    #where recipient_id = user
    user_messages = []
    user_groups = UserGroup.where(user_id: User.find(decode_jwt(cookies.signed[:jwt])["user_id"])).pluck(:group_id)
    user_groups.each do |grp| 
      message_ids = MessageRecipient.where(recipient_group_id: grp)
      messages = Message.where(id: message_ids.map{|msg_id| msg_id["message_id"]})
      user_messages.push([grp, message_ids, messages])
    end
    # @message_ids=MessageRecipient.where( recipient_id: retrieve_message_params[:userId] )
    # User.find(retrieve_message_params[:userId])
    #for each message_id, add the message
    # @message_ids.map{|mid| mid["message_id"]}
    # @messages=Message.where(id: @message_ids.map{|mid| mid["message_id"]})
    
    render json: {messages: user_messages}
  end
  # Selecting messages for a conversation

  # two cases
  
  # 1: most recent message is from someone else
  # get message_ids from message_recipients where recipient_id = user_id, is_read = false,
  # for each message_id:
  # get message, creator_id, and recipient_id. if parent_id isn't zero,
  # select message_id is parent_id till parent_id is zero
  # check
  
  # 2: most recent message is first from user to another recipient
  # message_ids=select from messages where creator is user
  # messages_to_send = select from message_recipient where message_id && is_read is false
  def delete
    message = Message.find(del_message_params[:delmessage])
    message_recipients=MessageRecipient.where(message_id: message.id)
    message_recipients.destroy_all
    message.destroy
  end

  private

  def message_params
    params.require(:message).permit(:message_body, :user2, :user_groups, :parent_id)
  end

  def del_message_params
    params.require(:message).permit(:delmessage)
  end

end
