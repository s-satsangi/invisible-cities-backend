class UserGroup < ApplicationRecord
    belongs_to :user
    # the primary key won't denote groups.
    # we insert two users and they gotta both have
    # the same group id.
    # what we really have to do when we make a 
    # new group is look at the most
    # recent group_id entry here and add 1.
end
