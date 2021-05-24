class ConvertIdsInCategoriesToUuid < ActiveRecord::Migration[6.0]
  def up
    add_column :categories, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :categories, :id, :integer_id
    rename_column :categories, :uuid, :id
    execute "ALTER TABLE categories drop constraint categories_pkey;"
    execute "ALTER TABLE categories ADD PRIMARY KEY (id);"

    # remove integer_id column
    remove_column :categories, :integer_id

    # update account_id foreign key
    add_column :categories, :account_uuid, :uuid, null: false
    rename_column :categories, :account_id, :account_integer_id
    rename_column :categories, :account_uuid, :account_id
    remove_column :categories, :account_integer_id
    add_index :categories, :account_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
