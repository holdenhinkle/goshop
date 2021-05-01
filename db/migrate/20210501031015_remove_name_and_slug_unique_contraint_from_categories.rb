class RemoveNameAndSlugUniqueContraintFromCategories < ActiveRecord::Migration[6.0]
  def change
    remove_index :categories, :name
    remove_index :categories, :slug
    add_index :categories, :name
    add_index :categories, :slug
  end
end
