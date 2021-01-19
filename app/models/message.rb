class Message < ApplicationRecord
    belongs_to :user, class_name: "User", optional: true
    has_many :message_recipient

    # belongs_to :parent, class_name: "message", :foreign_key => "parent_id"
    # has_one :child, class_name: "message", :foreign_key => "parent_id"
end
