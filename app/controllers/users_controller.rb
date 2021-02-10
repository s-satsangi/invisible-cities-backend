class UsersController < ApplicationController
    #from the flatiron auth tutorial
    #skip checking if user is logged in for methods in only block:
    skip_before_action :authenticate_user, only: [:create]
    
    
    def index
        users=User.all
        # byebug
        render json: {users: users}
    end
    # I think we can get away with all functions being available to non-authenticated users
    # this controller needs functions to 
    # create a user
    # login them in
    # make them inactive/delete?
    # update? edit?
    # params
    def create
#currently written for flatiron jwt stuff.  if 
#user logs in, issues a token and sends it to frontend
        puts "Ayyyyy"
        # byebug
        @user=User.new(user_params)
        if !@user.save
            return render json: { message: "some kinda wrong just happend"}, status: :not_acceptable
        end
        #
        #   More flatiron auth stuff
        #
                @token = encode_token(user_id: @user.id)
        # do user created things. make a token & throw at browser if you do auth
        render json: {user: @user, jwt: @token}, status: :created
    end

    def delete
        puts "delete"
    end

    def update
        puts "update"
    end

    #endpoint to search for users to add or block
    def search
        # byebug
        search_user = User.find_by(username: user_params[:username])
        render json: { user: search_user }
    end

#
#   More flatiron auth stuff
#
    def profile
        # render json: { user: UserSerializer.new(current_user) }, status: :accepted
        render json: {username: current_user.username, bio: current_user.bio, avatar: current_user.avatar }
    end

#   end of more flatiron auth stuff
    private

    def user_params
        params.require(:user).permit(:username, :password, :bio)
    end

end
