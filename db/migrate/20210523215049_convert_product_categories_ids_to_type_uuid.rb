class ConvertProductCategoriesIdsToTypeUuid < ActiveRecord::Migration[6.0]
  def change
    # handle product_id
    add_column :product_categories, :product_uuid, :uuid, null: false
    rename_column :product_categories, :product_id, :product_integer_id
    rename_column :product_categories, :product_uuid, :product_id
    remove_column :product_categories, :product_integer_id
    add_foreign_key :product_categories, :products, column: :product_id
    add_index :product_categories, :product_id

    # handle category_id
    add_column :product_categories, :category_uuid, :uuid, null: false
    rename_column :product_categories, :category_id, :category_integer_id
    rename_column :product_categories, :category_uuid, :category_id
    remove_column :product_categories, :category_integer_id
    add_foreign_key :product_categories, :categories, column: :category_id
    add_index :product_categories, :category_id
  end
end
