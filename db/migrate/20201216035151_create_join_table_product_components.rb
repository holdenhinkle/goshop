class CreateJoinTableProductComponents < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :components do |t|
      t.index :product_id
      t.index :component_id
    end
  end
end
