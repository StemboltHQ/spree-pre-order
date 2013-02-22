class FixDecimalTypeForPreorderPrices < ActiveRecord::Migration
  def up
    change_column :spree_preorder_prices, :amount, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :spree_preorder_prices, :amount, :decimal, :precision => 10, :scale => 0
  end
end
