class AddNotNullContraintToAccountsIdInProducts < ActiveRecord::Migration[6.0]
  def change
    change_column_null :products, :accounts_id, false
  end
end
