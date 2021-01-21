class AuthController < ApplicationController
  def create
    # byebug
    if User.where(username: auth_params[:username])
      @user = User.where(username: auth_params[:username])
      return render json: {user: @user}
    end
    render json: { message: "user not found.  create an account and start chatting!" }
  end

  private

  def auth_params
    params.require(:user).permit(:username)
  end
end
