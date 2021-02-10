class ApplicationController < ActionController::API
    # from JWT HTTPonly tutorial:
    include ::ActionController::Cookies
    # end HTTPonly
    # from walking through the flatiron JWT tutorial
    #before_action :authorized

    #instead, let's use authenticate user
    before_action :authenticate_user

    # takes a payload and returns a jwt string
    def encode_token(payload)
        # I expect something like payload => { userid: int }
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def auth_header
        # So, in the fetch request, we expect the headers to contain an authorization,
        # which will make our fetch request look something like:
        # fetch('http://localhost:3000/myRestfulApiEndpoint', {
        #     method: 'GET',
        #     headers: {
        #       Authorization: `Bearer <token>`
        #     }
        #   })
        #
        # this function returns 'Bearer <token>' if this is in
        # the headers.  I guess this goes in the toilet
        # when we make httpOnly 
        request.headers['Authorization'] 
    end

    # def decoded_token(token)
        #I expect the token to be a jwt-string

        #decode and return the payload object

    #     if auth_header 
    #         token = auth_header.split(' ')[1]
    #         # token is the <token> passed in fetch
    #         begin
    #             JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')[0]
    #         rescue
    #             # we're here because the token is bad.  Send
    #             # nil back and avoid a 500 error/server crash
    #             nil
    #         end
    #     end
    # end
    def decode_jwt(jwt)
        #check the headers in post for jwt
        # byebug
        # if auth_header  
            # token = cookies.signed[:jwt]
            # auth_header.split(' ')[1]
            begin
                # decode the token, return the decoded part
                JWT.decode(jwt, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')[0]
            rescue JWT::DecodeError 
                # byebug 
                # render json: {message: "NOPE!!!! Really no!"}, status: :unauthorized

                nil
            end
        # end
    end

    def current_user
        #decoded_token returns either the payload object or nil
        # byebug
        #if decoded_token

        if decode_jwt(cookies.signed[:jwt])
            #we're just gonna assume that we are
            #encoding a user_id here
            user_id = decode_jwt(cookies.signed[:jwt])
            #pretty sure we don't need an @ but what the hell
            @user = User.find_by(id: user_id)
        end
    end

    def logged_in?
        # if token got passed into the api endpoint (via the authorization key in headers in fetch)
        # then we decode the token, check if there's a
        # 'user_id' key, and convert it's corresponding value
        # to a boolean.  Expect this to only be false when not logged in
        !!current_user
    end

    def authorized
        # if logged_in? returns true, we send this message to the frontend.
        # else, this should let the code everywhere else execute
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

# end of flatiron stuff on JWT

##
#JWT HTTPonly stuff
    def authenticate_user
        jwt=cookies.signed[:jwt]
        decode_jwt(jwt)        
    end
##

private
  
def require_login
  unless logged_in?
    render json: {error: "I'm pretty sure you're logged in.  This should be working.  Why isn't this working?  Log in harder."}
  end 
end
end
