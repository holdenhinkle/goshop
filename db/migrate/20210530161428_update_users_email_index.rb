class UpdateUsersEmailIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, name: "index_users_on_email"
    add_index :users, [:accounts_id, :email], unique: true
  end
end
