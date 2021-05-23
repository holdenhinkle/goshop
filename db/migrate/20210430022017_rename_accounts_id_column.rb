class RenameAccountsIdColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :accounts_id, :account_id
  end
end
