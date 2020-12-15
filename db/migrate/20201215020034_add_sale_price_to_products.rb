class AddSalePriceToProducts < ActiveRecord::Migration[6.0]
  def change
    add_monetize :products, :sale_price, amount: { null: true, default: nil }
  end
end
