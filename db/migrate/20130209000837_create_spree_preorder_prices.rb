class CreateSpreePreorderPrices < ActiveRecord::Migration
  def change
    create_table :spree_preorder_prices do |t|
      t.integer :price_id
      t.decimal :amount
      t.string :currency

      t.timestamps
    end
  end
end
