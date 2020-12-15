class RemoveSalePriceCentsFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :sale_price_cents, :integer
  end
end
