class UsersController < ApplicationController
    # I think we can get away with all functions being available to non-authenticated users
    # this controller needs functions to 
    # create a user
    # login them in
    # make them inactive/delete?
    # update? edit?
    # params
    def create
        byebug
        @user=User.new(user_params)
        if !@user.save
            return render json: {status: "error", message: "some kinda wrong just happend"}
        end
        # do user created things. make a token & throw at browser if you do auth
        render json: {user: @user}, status: :created
    end

    private

    def user_params
        params.require(:user).permit(:username)
    end

end
