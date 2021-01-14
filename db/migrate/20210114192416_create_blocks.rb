class CreateBlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :blocks do |t|
      t.integer :blocker_id
      t.integer :blockee_id

      t.timestamps
    end
  end
end
