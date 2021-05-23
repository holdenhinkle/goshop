class ConvertIdsInComponentsToUuid < ActiveRecord::Migration[6.0]
  def up
    add_column :components, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :components, :id, :integer_id
    rename_column :components, :uuid, :id
    execute "ALTER TABLE components drop constraint components_pkey;"
    execute "ALTER TABLE components ADD PRIMARY KEY (id);"

    # remove integer_id column
    remove_column :components, :integer_id

    # update account_id foreign key
    add_column :components, :account_uuid, :uuid, null: false
    rename_column :components, :account_id, :account_integer_id
    rename_column :components, :account_uuid, :account_id
    remove_column :components, :account_integer_id
    add_index :components, :account_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
