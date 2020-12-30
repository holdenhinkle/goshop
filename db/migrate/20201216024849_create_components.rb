class CreateComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :components do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :slug
      t.string :image
      t.integer :min_quantity, null: false, default: 1
      t.integer :max_quantity
      t.boolean :is_enabled, null: false, default: true
      t.timestamps
    end

    add_index :components, :slug, unique: true
  end
end
