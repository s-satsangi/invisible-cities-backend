class FollowController < ApplicationController
  def create
    byebug
    # creates follow relation both ways
    # once we've got that working, we can write a request function
    # that can handle sending a message to a potential friend and 
    # getting response/permissions/etc

    # so, we can assume both people consent in this function
  end

  def index
    @user=User.where(username: count_params[:username])
    followers=Follow.where(followee_id: @user.ids[0])  
    render json: {followers: followers}
  end

  def number_for_profile
    # byebug
    @user=User.where(username: count_params[:username])
    numfollowers=Follow.where(followee_id: @user.ids[0]).count 
    numblocked=Block.where(blockee_id: @user.ids[0]).count
    render json: {followers: numfollowers, blocked: numblocked}
  end


  def follow_handshake
    # called when a user wants to add another as a friend
    # base functionality:
    # check if relation is in blocked table
    # refuse if user is blocked, remove block if reverse relationship
    # sends a message to the other user and 
    #     if: user responds yes > call create
    #     if: user responds no > call block

  end

  def block
    # if relationship exists, remove from Follow
    # add one-way to block
    
  end

  private

  def follow_params
    params.require(:follow).permit(:user1, :user2)
  end

  def count_params
    params.require(:user).permit(:username)
  end

end
