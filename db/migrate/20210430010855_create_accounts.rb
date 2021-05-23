class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :tentant_id, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :accounts, :tentant_id
  end
end
