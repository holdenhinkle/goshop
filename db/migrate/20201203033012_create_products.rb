class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :image
      t.integer :regular_price, null: false
      t.integer :sale_price
      t.integer :inventory_amount
      t.string :inventory_unit_type
      t.boolean :is_visible, null: false, default: true
      t.timestamps
    end
  end
end
