class AddAccountIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :accounts, type: :uuid, foreign_key: true, column: :accounts_id
  end
end
