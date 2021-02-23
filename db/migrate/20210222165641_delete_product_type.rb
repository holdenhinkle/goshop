class DeleteProductType < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :type
  end
end
