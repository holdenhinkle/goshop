class AddNotNullToCategoriesAccountId < ActiveRecord::Migration[6.0]
  def change
    change_column_null :categories, :account_id, false
  end
end
