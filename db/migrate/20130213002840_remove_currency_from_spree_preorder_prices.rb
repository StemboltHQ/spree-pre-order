class RemoveCurrencyFromSpreePreorderPrices < ActiveRecord::Migration
  def change
    remove_column :spree_preorder_prices, :currency
  end
end
