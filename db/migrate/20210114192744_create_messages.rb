class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :creator_id
      t.string :message_body
      t.integer :parent_id

      t.timestamps
    end
  end
end
