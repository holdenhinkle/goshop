class CreateJoinTableComponentProducts < ActiveRecord::Migration[6.0]
  def change
    create_join_table :components, :products do |t|
      t.index :component_id
      t.index :product_id
    end
  end
end
