class AddTypeToProductsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :type, :string, null: false
    add_index :products, :type
  end
end
