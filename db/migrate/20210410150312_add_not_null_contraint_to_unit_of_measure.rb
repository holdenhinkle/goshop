class AddNotNullContraintToUnitOfMeasure < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :unit_of_measure, :string, null: false
  end
end
