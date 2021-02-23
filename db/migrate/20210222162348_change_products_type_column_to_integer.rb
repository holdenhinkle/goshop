class ChangeProductsTypeColumnToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :type, :string
  end
end
