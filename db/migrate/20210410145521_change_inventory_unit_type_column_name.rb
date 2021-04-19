class ChangeInventoryUnitTypeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :inventory_unit_type, :unit_of_measure
  end
end