class ChangeAvailableTenantIdsIdTypeToUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :available_tenant_ids, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :available_tenant_ids, :id, :integer_id
    rename_column :available_tenant_ids, :uuid, :id
    execute "ALTER TABLE available_tenant_ids drop constraint available_tenant_ids_pkey;"
    execute "ALTER TABLE available_tenant_ids ADD PRIMARY KEY (id);"

    # remove auto-incremented default value for integer_id column
    execute "ALTER TABLE ONLY available_tenant_ids ALTER COLUMN integer_id DROP DEFAULT;"
    change_column_null :available_tenant_ids, :integer_id, true
    execute "DROP SEQUENCE IF EXISTS available_tenant_ids_id_seq"
    remove_column :available_tenant_ids, :integer_id
  end
end
