class AddColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :avatar, :string
    add_column :users, :bio, :string
  end
end
