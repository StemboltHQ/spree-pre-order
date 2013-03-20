Spree::Payment.class_eval do
  after_initialize :steal_source_from_initial

  def initial_payment
    Spree::Payment.where(order_id: order.id).where('source_id IS NOT NULL').first if order
  end

  def steal_source_from_initial
    self.source = initial_payment.source if !source && initial_payment
  end
end
