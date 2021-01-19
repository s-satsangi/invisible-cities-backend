class MessageRecipient < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :message, optional: true
end
