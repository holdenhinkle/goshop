class AddUnitTypeUnitOfMeasurement < ActiveRecord::Migration[6.0]
  def up
    remove_column :products, :unit_of_measure

    execute <<-SQL
      CREATE TYPE product_unit AS ENUM ('piece', 'gallon', 'quart', 'pint', 'cup', 'fluid_once', 'tablespoon', 'teaspoon', 'pound', 'ounce');
    SQL

    add_column :products, :unit_of_measure, :product_unit, default: 'piece', null: false
    change_column_default :products, :unit_of_measure, from: 'piece', to: nil
  end

  def down
    remove_column :products, :unit_of_measure
    add_column :products, :unit_of_measure, :string, default: 'piece', null: false
    change_column_default :products, :unit_of_measure, from: 'piece', to: nil

    execute <<-SQL
      DROP TYPE product_unit;
    SQL
  end
end
