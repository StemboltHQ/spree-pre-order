class Spree::PreorderPrice < ActiveRecord::Base
  attr_accessible :amount, :price_id

  validates :amount, :price_id, presence: true

  belongs_to :price, class_name: "Spree::Price"

  delegate :currency, to: :price

  def money
    Spree::Money.new(amount, currency: currency)
  end
end
