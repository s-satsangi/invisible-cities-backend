class User < ApplicationRecord
    has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
    has_many :followees, through: :followed_users
    has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
    has_many :followers, through: :following_users

    has_many :blocked_users, foreign_key: :blocker_id, class_name: 'Block'
    has_many :blockees, through: :blocked_users
    has_many :blocking_users, foreign_key: :blockee_id, class_name: 'Block'
    has_many :blockers, through: :blocking_users

    has_many :messages
    has_secure_password
    validates :username, uniqueness: {case_sensitive: false}
end
