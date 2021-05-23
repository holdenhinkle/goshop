class RenameAvailableTenantIdColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :available_tenant_ids, :name, :tenant_id
  end
end
