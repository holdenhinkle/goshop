class ConvertComponentProductOptionsIdsToTypeUuid < ActiveRecord::Migration[6.0]
  def change
    # handle component_id update
    add_column :component_product_options, :component_uuid, :uuid, null: false
    rename_column :component_product_options, :component_id, :component_integer_id
    rename_column :component_product_options, :component_uuid, :component_id
    remove_column :component_product_options, :component_integer_id
    add_index :component_product_options, :component_id
    add_foreign_key :component_product_options, :products, column: :component_id

    # handle product_id update
    add_column :component_product_options, :product_uuid, :uuid, null: false
    rename_column :component_product_options, :product_id, :product_integer_id
    rename_column :component_product_options, :product_uuid, :product_id
    remove_column :component_product_options, :product_integer_id
    add_index :component_product_options, :product_id
    add_foreign_key :component_product_options, :categories, column: :product_id

    # add composite index
    add_index :component_product_options,
      ['component_id', 'product_id'],
      unique: true,
      name: 'idx_component_product_options_on_component_id_and_product_id'
  end
end
