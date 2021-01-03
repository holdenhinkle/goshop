class AddUniqueIndexToProductComponentsTable < ActiveRecord::Migration[6.0]
  def change
    add_index :product_components, [:product_id, :component_id], unique: true
  end
end
