class RemoveNameAndSlugUniqueContraintFromComponents < ActiveRecord::Migration[6.0]
  def change
    remove_index :components, :name
    remove_index :components, :slug
    add_index :components, :name
    add_index :components, :slug
  end
end
