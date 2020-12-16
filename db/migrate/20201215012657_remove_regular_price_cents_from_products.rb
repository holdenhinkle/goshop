class RemoveRegularPriceCentsFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :regular_price_cents, :integer
  end
end
