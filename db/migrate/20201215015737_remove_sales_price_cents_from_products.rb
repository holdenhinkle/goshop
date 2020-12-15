class RemoveSalesPriceCentsFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :sales_price_cents, :integer
  end
end
