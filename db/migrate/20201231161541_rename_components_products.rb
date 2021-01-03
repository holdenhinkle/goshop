class RenameComponentsProducts < ActiveRecord::Migration[6.0]
  def change
    rename_table :components_products, :component_products
  end
end
