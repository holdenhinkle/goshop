class RenameCategoriesProducts < ActiveRecord::Migration[6.0]
  def change
    rename_table :categories_products, :product_categories
  end
end
