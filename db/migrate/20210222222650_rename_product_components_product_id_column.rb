class RenameProductComponentsProductIdColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :product_components, :product_id, :composite_id
  end
end
