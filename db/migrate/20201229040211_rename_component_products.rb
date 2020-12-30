class RenameComponentProducts < ActiveRecord::Migration[6.0]
  def change
    rename_table :components_products, :product_components
  end
end
