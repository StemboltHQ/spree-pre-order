Spree::LineItem.class_eval do
  def preorder_amount
    variant.preorder_amount(order.currency) * quantity
  end
end
