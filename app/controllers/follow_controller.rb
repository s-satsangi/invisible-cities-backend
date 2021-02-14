class FollowController < ApplicationController
  def create
    byebug
    # creates follow relation both ways
    # once we've got that working, we can write a request function
    # that can handle sending a message to a potential friend and 
    # getting response/permissions/etc

    # so, we can assume both people consent in this function
  end

  #endpoint to return all friends
  def index

  # when we build our friends to send to frontend, we select where 
  # user_id=followee_id, let's call those half-follows. for_each 
  # of those half_follow_ids, we can cycle through and see if 
  # half_follow follower_id exists as followee with user_id as 
  # follower. If so, push to friends, if not, push to pending.
  #   :return friend and pending objects to display appropriately

    @user=User.where(username: count_params[:username])
    half_follows = Follow.where(followee_id: @user.ids[0])
    follow_back = Follow.where(follower_id: @user.ids[0])
    # byebug
    buddies_first=half_follows.partition {|record| Follow.find_by(follower_id: @user.ids[0], followee_id: record.follower_id)}
    # byebug
    friends_ids = buddies_first[0].map{|bud| bud.follower_id}
    friends = User.find(friends_ids)
    # cycle through half_follow, for each record, if
    # Follow.find_by(follower: @user.ids[0] followee: record.follower_id )
    pending_buds_ids = buddies_first[1].map{|bud| bud.follower_id}
    pending_buds = User.find(pending_buds_ids)
    #whatever's left
    half_sent_requests = Follow.where(follower_id: @user.ids[0])
    sent_requests = half_sent_requests.partition {|record| Follow.find_by(follower_id: record.followee_id, followee_id: @user.ids[0]) }[1]
    sent_requests_ids = sent_requests.map{|bud| bud.followee_id}
    waiting_on = User.find(sent_requests_ids)
    # followers=Follow.where(followee_id: @user.ids[0])  
    render json: {followers: friends, requests: pending_buds, sent_requests: waiting_on}
  end

  # endpoint to send a friend request
  def add_friend
    # byebug
    #we get user_id from jwt!
    user = User.find(decode_jwt(cookies.signed[:jwt])["user_id"])
    #we get friend_id from frontend
    followee = User.find(follow_params[:user2])
    #insert the one way relation in db!
    friend_request = Follow.new(follower_id: user.id, followee_id: followee.id)
    if friend_request.save
      render json: {friend_request: followee} 
    else
      render json: {error:  "There was a problem!"}
    end
  end

  # endpoint to accept friend request
  def reply_pos
    puts 'aw yeah!!!!'
    # byebug
    # we've got user from cookie
    # we're passing in the 2nd user from follow_params[:user2]
    ret_errors=[]
    half_follow_a = Follow.new(follower_id: decode_jwt(cookies.signed[:jwt])["user_id"], followee_id: follow_params[:user2])
    if !half_follow_a.save
      ret_errors.push("Failure in the first half of follow. ")
    end
    # half_follow_b = Follow.new(follower_id: follow_params[:user2], followee_id: decode_jwt(cookies.signed[:jwt])["user_id"])
    # if !half_follow_b.save
    #   ret_errors.push("Failure in the second half of follow.")
    # end
    if !!ret_errors
      render json: {ret_errors: ret_errors}
    else
      render json: {friend_request: "friendship established"}
    end
  end

  # endpoint to deny friend request
  def reply_neg
    puts 'AWW BOO'
    # byebug
    friend_deny=Follow.find_by(follower_id: follow_params[:user2], followee_id: decode_jwt(cookies.signed[:jwt])["user_id"])
    if friend_deny.destroy
      render json: {friend_deny: 'success'}
    else
      render json: {friend_deny: 'failure'}
    end
  end


  # endpoint for blocking
  def block
    # byebug
    # if relationship exists, remove from Follow
    # add one-way to block
    ret_errors=[]
    
    follow_check_a = Follow.find_by(follower_id: decode_jwt(cookies.signed[:jwt])["user_id"], followee_id: follow_params[:user2])
    
    follow_check_b = Follow.find_by(follower_id: follow_params[:user2], followee_id: decode_jwt(cookies.signed[:jwt])["user_id"])
    
    if follow_check_a
      follow_check_a.destroy
    end

    if follow_check_b
      follow_check_b.destroy
    end

    block_half_a = Block.new(blocker_id: decode_jwt(cookies.signed[:jwt])["user_id"], blockee_id:follow_params[:user2])
    block_half_b = Block.new(blocker_id: follow_params[:user2],blockee_id: decode_jwt(cookies.signed[:jwt])["user_id"])
    if !block_half_a.save
      ret_errors.push("Failure of saving first half block. ")
    end
    if !block_half_b.save
      ret_errors.push("Failure of saving second half block. ")
    end
    if !!ret_errors
      render json: {ret_errors: ret_errors}
    else
      render json: {block_request: "block established"}
    end


  end

  #endpoint to return count of friends
  def number_for_profile
    # byebug
    # @user=User.where(username: count_params[:username])
    @user = User.find(decode_jwt(cookies.signed[:jwt])["user_id"])
    numfollowers=Follow.where(followee_id: @user.id).count 
    numblocked=Block.where(blockee_id: @user.id).count
    render json: {followers: numfollowers, blocked: numblocked}
  end


  def follow_handshake
#old shit begin
    # we expect an input of userId
    # we return the users that are followers in Follow
    # byebug
   @userId = follow_index_params[:userId]
   @followers = Follow.where(followee_id: @userId)
   followers_id=@followers.map{|follow| follow[:follower_id]}
   @friends = User.find(followers_id)
   render json: {friends: @friends}
  end

  # def friend_request
###old shit end
    # called when a user wants to add another as a friend
    # base functionality:
    # check if relation is in blocked table
    # refuse if user is blocked, remove block if reverse relationship
    # sends a message to the other user and 
    #     if: user responds yes > call create
    #     if: user responds no > call block

  # end

  ###############


  private

  def follow_index_params
    params.require(:follow).permit(:userId)
  end

  def follow_params
    params.require(:follow).permit(:user2)
  end

  def count_params
    params.require(:user).permit(:username)
  end

end
