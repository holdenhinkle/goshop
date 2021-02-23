class ChangeProductsProductTypeToType < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :product_type, :type
  end
end
