Spree::Order.class_eval do
  def preorder_total
    variants.sum { |variant| variant.preorder_amount(currency) }
  end
end
