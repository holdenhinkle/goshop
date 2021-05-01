class AddAccountIdToCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :categories, :accounts, foreign_key: true, column: :accounts_id
  end
end
