class ConvertAccountIdTypeToUuidInProductsTable < ActiveRecord::Migration[6.0]
  def up
    add_column :products, :account_uuid, :uuid, null: false
    rename_column :products, :account_id, :account_integer_id
    rename_column :products, :account_uuid, :account_id
    remove_column :products, :account_integer_id
    add_index :products, :account_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
