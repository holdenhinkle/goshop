class AddPriceColumnsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_monetize :products, :regular_price, null: false
    add_monetize :products, :sales_price, amount: { null: true, default: nil }
  end
end
