class AddNotNullToComponentsAccountId < ActiveRecord::Migration[6.0]
  def change
    change_column_null :components, :account_id, false
  end
end
