class AddCompositeIndexToProductCategories < ActiveRecord::Migration[6.0]
  def change
    add_index :product_categories,
    ['product_id', 'category_id'],
    unique: true,
    name: 'idx_product_categories_on_product_id_and_category_id'
  end
end
