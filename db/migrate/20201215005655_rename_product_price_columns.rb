class RenameProductPriceColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :regular_price, :regular_price_cents
    rename_column :products, :sale_price, :sale_price_cents
  end
end
