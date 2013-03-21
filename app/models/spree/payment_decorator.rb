Spree::Payment.class_eval do
  after_initialize :steal_source_from_initial

  def initial_payment
    Spree::Payment.where(order_id: order.id).where('source_id IS NOT NULL').where('response_code IS NOT NULL').first if order
  end

  def steal_source_from_initial
    self.source = initial_payment.source if !source && initial_payment
  end

  def gateway_order_id
    if self.initial_payment
      initial_payment.response_code.split('|').first
    else
      "#{order.number}-#{self.identifier}"
    end
  end

  # Most of this is taken from spree core
  # We are modifying what the gateway is for the additional payment
  def gateway_options
    options = { :email    => order.email,
                :customer => order.email,
                :ip       => order.last_ip_address,
                :order_id => gateway_order_id } # This is the changed line

    options.merge!({ :shipping => order.ship_total * 100,
                     :tax      => order.tax_total * 100,
                     :subtotal => order.item_total * 100 })

    options.merge!({ :currency => currency })

    options.merge!({ :billing_address  => order.bill_address.try(:active_merchant_hash),
                    :shipping_address => order.ship_address.try(:active_merchant_hash) })

    options.merge!(:discount => promo_total) if respond_to?(:promo_total)
    options
  end
end
