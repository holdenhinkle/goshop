class AddIndexToComponents < ActiveRecord::Migration[6.0]
  def change
    add_index :components, :name, unique: true
  end
end
