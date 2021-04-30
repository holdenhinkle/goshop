class ChangeColumnNameInAccounts < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :tentant_id, :tenant_id
  end
end
