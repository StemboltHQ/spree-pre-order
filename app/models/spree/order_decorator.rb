Spree::Order.class_eval do
  def initial_payment_total
    line_items.map(&:initial_payment_amount).compact.inject(:+)
  end
end
