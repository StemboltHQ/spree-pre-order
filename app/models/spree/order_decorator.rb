Spree::Order.class_eval do
  def initial_payment_total
    line_items.map(&:preorder_amount).compact.inject(:+)
  end
end
