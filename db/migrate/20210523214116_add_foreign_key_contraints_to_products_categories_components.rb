class AddForeignKeyContraintsToProductsCategoriesComponents < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :products, :accounts, column: :account_id
    add_foreign_key :categories, :accounts, column: :account_id
    add_foreign_key :components, :accounts, column: :account_id
  end
end
