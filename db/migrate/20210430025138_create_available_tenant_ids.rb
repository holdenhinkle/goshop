class CreateAvailableTenantIds < ActiveRecord::Migration[6.0]
  def change
    create_table :available_tenant_ids do |t|
      t.string :name, null: false
    end
  end
end
