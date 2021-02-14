class AuthController < ApplicationController
  #from the flatiron auth tutorial
  # skip_before_action :authorized, only: [:create]
  #end flatiron auth
  #from JWT HTTPonly auth
  
  #end

  def create
  #   # byebug
  #   if User.where(username: auth_params[:username])
  #     @user = User.where(username: auth_params[:username])
  #     return render json: {user: @user}
  #   end
  #   render json: { message: "user not found.  create an account and start chatting!" }
  
  #switchin from flatiron auth to HTTPonly
    @user = User.find_by(username: auth_params[:username])
    # the #authenticate method below is from BCrypt
    if @user && @user.authenticate(auth_params[:password])
      # encode_token comes from ApplicationController
      created_jwt = encode_token({ user_id: @user.id })
      cookies.signed[:jwt] = {value: created_jwt, httponly: true}
      render json: { user: @user.username, uid: @user.id }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  #end of HTTPONLY
  end

  def destroy
    if cookies.delete :jwt
      return render json: {logout: "success!"}
    else
      return render json: {logout: "suck eggs!"}
    end
  end
  
  private

  def auth_params
    params.require(:user).permit(:username, :password)
  end
end
