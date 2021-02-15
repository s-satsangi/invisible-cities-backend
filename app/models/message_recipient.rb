class MessageRecipient < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :message, optional: true

    # def as_json
    #     super.merge('created_at' => self.created_at.strftime("%d %b "))
    #   end
end
