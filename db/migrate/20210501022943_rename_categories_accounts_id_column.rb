class RenameCategoriesAccountsIdColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :categories, :accounts_id, :account_id
  end
end
