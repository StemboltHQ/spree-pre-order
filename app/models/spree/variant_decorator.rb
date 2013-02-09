Spree::Variant.class_eval do
  def preorder_price(currency)
    price_in(currency).preorder_price
  end

  def preorder_amount(currency)
    preorder_price(currency).try(:amount)
  end
end
