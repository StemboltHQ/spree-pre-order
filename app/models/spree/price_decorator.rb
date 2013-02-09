Spree::Price.class_eval do
  has_one :preorder_price, class_name: "Spree::PreorderPrice"
end
