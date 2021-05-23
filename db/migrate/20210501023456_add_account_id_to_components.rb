class AddAccountIdToComponents < ActiveRecord::Migration[6.0]
  def change
    add_reference :components, :accounts, foreign_key: true
    rename_column :components, :accounts_id, :account_id
  end
end
