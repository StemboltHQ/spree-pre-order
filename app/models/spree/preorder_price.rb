class Spree::PreorderPrice < ActiveRecord::Base
  attr_accessible :amount, :price_id

  validates :amount, :price_id, presence: true

  belongs_to :price, class_name: "Spree::Price"
end
