class AddUniqueIndexToSpreePreorderPricesPriceId < ActiveRecord::Migration
  def change
    add_index :spree_preorder_prices, :price_id, unique: true
  end
end
