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
end
