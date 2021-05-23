class ConvertAccountsIdsToUuid < ActiveRecord::Migration[6.0]
  def up
    add_column :accounts, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :accounts, :id, :integer_id
    rename_column :accounts, :uuid, :id
    execute "ALTER TABLE accounts drop constraint accounts_pkey cascade;"
    execute "ALTER TABLE accounts ADD PRIMARY KEY (id);"

    # remove auto-incremented default value for integer_id column
    execute "ALTER TABLE ONLY accounts ALTER COLUMN integer_id DROP DEFAULT;"
    change_column_null :accounts, :integer_id, true
    execute "DROP SEQUENCE IF EXISTS accounts_id_seq"
    remove_column :accounts, :integer_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
