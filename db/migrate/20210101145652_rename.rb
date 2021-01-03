class Rename < ActiveRecord::Migration[6.0]
  def change
    rename_table :component_products, :component_product_options
  end
end
