class AddTypeToProducts < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE product_type AS ENUM ('simple', 'composite', 'configured_composite');
    SQL
    add_column :products, :type, :product_type, null: false
    add_index :products, :type
  end

  def down
    execute <<-SQL
      DROP TYPE product_type
    SQL
    remove_column :products, :type
  end
end
