class AddAccountIdToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :accounts, foreign_key: true
  end
end
