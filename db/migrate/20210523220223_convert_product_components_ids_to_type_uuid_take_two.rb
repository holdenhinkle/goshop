class ConvertProductComponentsIdsToTypeUuidTakeTwo < ActiveRecord::Migration[6.0]
  def change
    # remove composite index
    remove_index :product_components, name: 'index_product_components_on_composite_id_and_component_id'

    # handle composite_id
    add_column :product_components, :composite_uuid, :uuid, null: false
    rename_column :product_components, :composite_id, :composite_integer_id
    rename_column :product_components, :composite_uuid, :composite_id
    remove_column :product_components, :composite_integer_id
    add_index :product_components, :composite_id
    add_foreign_key :product_components, :products, column: :composite_id

    # handle component_id
    add_column :product_components, :component_uuid, :uuid, null: false
    rename_column :product_components, :component_id, :component_integer_id
    rename_column :product_components, :component_uuid, :component_id
    remove_column :product_components, :component_integer_id
    add_index :product_components, :component_id
    add_foreign_key :product_components, :categories, column: :component_id

    # add composite index
    add_index :product_components,
      ['composite_id', 'component_id'],
      unique: true,
      name: 'idx_product_components_on_composite_id_and_component_id'
  end
end
