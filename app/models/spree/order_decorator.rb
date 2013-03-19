Spree::Order.class_eval do
  def preorder_total
    line_items.map(&:preorder_amount).compact.inject(:+)
  end
end
