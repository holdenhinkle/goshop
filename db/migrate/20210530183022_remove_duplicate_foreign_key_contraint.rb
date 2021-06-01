class RemoveDuplicateForeignKeyContraint < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :users, name: 'fk_rails_8f58d885f9'
  end
end
