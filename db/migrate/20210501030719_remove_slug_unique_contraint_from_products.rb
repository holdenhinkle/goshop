class RemoveSlugUniqueContraintFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_index :products, :slug
    add_index :products, :slug
  end
end
