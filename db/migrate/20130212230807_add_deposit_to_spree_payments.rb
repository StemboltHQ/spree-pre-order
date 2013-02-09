class AddDepositToSpreePayments < ActiveRecord::Migration
  def change
    add_column :spree_payments, :deposit, :boolean
  end
end
