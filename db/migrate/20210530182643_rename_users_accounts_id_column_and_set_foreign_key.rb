class RenameUsersAccountsIdColumnAndSetForeignKey < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :accounts_id, :account_id
    add_foreign_key :users, :accounts, column: :account_id
  end
end
