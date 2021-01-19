class FollowController < ApplicationController
  def create
    byebug
  end

  private

  def follow_params
    params.require(:follow).permit(:user1, :user2)
  end

end
