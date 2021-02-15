class UserGroupController < ApplicationController

    #endpoint to list all groups user belongs to
    def index
        user = User.find(decode_jwt(cookies.signed[:jwt])["user_id"])
        #gives us the user_groups for the user
        user_groups = UserGroup.where(user_id: user.id)
        #build a hash where the key is group_id 
        #& value is the members of group
        ret_keys = user_groups.map{|group| group.group_id}
        user_ids = ret_keys.map{|group| UserGroup.where(group_id: group).pluck("user_id")}
        # byebug
        vals = user_ids.map{|usr_ary| User.where(id: usr_ary)}
        # byebug
        ret_obj=ret_keys.zip(vals)
#################################################
#               console  play
# let ret_obj = {}
# first_hit = UserGroup.where(user_id: 4)
# groups = first_hit.map{|hit| hit.group_id}

# vals = groups.map{|group| UserGroup.where(group_id: group).pluck("user_id")}

# ret_obj = Hash[groups.zip(vals)]
#You need to retool this for multiple users
#user_ids = [[4, 5, 6], [2,3]]
#wanted = user_ids.map{|usr_ary| User.where(id: usr_ary)}
#################################################
        render json: {user_groups: [ret_obj]}

    end
    
    #endpoint to add users to group
    def add_to_group
        byebug
    end
    
    #endpoint to remove users from group
    def boot_from_group
        byebug
    end

    # endpoint to create new group
    def create
        # byebug
       #group doesn't exist, for the future it 
       #would be cool to check if group exists
       new_group_id = UserGroup.last.group_id + 1
    #    byebug
       user_group_params.each do |user|
            new_group = UserGroup.new(user_id: user, group_id: new_group_id)
            if !new_group.save
                return render json: {status: "error", new_group_creation: "failure"}
            end
       end
       return render json: {status: "success"}
    end

    private

    def user_group_params
        params.require(:user_group)
    end
end
