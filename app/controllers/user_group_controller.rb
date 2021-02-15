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
        render json: {user_groups: [ret_obj]}

    end
    
    #endpoint to add users to group
    def add_to_group
        # byebug
        add_group_id = user_group_params[1]
        new_members = user_group_params[0]

        new_members.each do |member|
            new_group = UserGroup.new(user_id: member, group_id: add_group_id)
            if !new_group.save
                return render json: {status: "error", add_user_to_group_creation: "failure"}
            end
        end
        return render json: {status: "success"}
    end
    
    #endpoint to remove users from group
    def boot_from_group
        # byebug
        boot_group_id = user_group_params[1]
        boot_members = user_group_params[0]
        
            boot_from_group = UserGroup.where(user_id: boot_members, group_id: boot_group_id)
            if !boot_from_group.destroy_all
                return render json: {status: "error", boot_users_from_group: "failure"}
            end        
            return render json: {status: "success"}
    end

    # endpoint to create new group
    def create
        # byebug
       #group doesn't exist, for the future it 
       #would be cool to check if group exists
       new_group_id = UserGroup.last.group_id + 1
    #    byebug
       user_group_params[0].each do |user|
            new_group = UserGroup.new(user_id: user, group_id: new_group_id)
            if !new_group.save
                return render json: {status: "error", new_group_creation: "failure"}
            end
       end
       return render json: {status: "success"}
    end

    def delete_group
        # find entries for:
        # UserGroup, MessageRecipient, & Message
        del_group_id=user_group_params[1]
        del_user_group_entries = UserGroup.where(group_id: del_group_id)
        del_group_message_recipient = MessageRecipient.where(recipient_group_id: del_group_id)
        del_messages = Message.where(id: del_group_message_recipient.pluck(:message_id))
        # destroy_all entries
        del_user_group_entries.destroy_all
        del_messages.destroy_all
        del_group_message_recipient.destroy_all
        render json: { destry: "Group destroyed" }
    end

    private

    def user_group_params
        params.require(:user_group)
    end
end
