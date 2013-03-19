Spree::LineItem.class_eval do
  def initial_payment_amount
    (variant.preorder_amount(order.currency) || variant.price_in(order.currency).amount) * quantity
  end
end
