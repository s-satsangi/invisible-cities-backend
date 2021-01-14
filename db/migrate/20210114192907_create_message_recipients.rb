class CreateMessageRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :message_recipients do |t|
      t.integer :recipient_id
      t.integer :recipient_group_id
      t.integer :message_id
      t.boolean :is_read

      t.timestamps
    end
  end
end
