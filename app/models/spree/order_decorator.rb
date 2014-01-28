Spree::Order.class_eval do
  def initial_payment_total
    line_items.map(&:initial_payment_amount).compact.inject(:+)
  end

  private

  # We are overriding the callback method in Spree core here instead of
  # setting a new one because we cannot guarentee in what order the callbacks would be
  # called. As this functionality, and that of Spree's both override the payment totals
  # order becomes important.
  def update_params_payment_source
    if self.payment?
      # From Spree Core
      if @updating_params[:payment_source].present? && source_params = @updating_params.delete(:payment_source)[@updating_params[:order][:payments_attributes].first[:payment_method_id].underscore]
        @updating_params[:order][:payments_attributes].first[:source_attributes] = source_params
      end
      # End Spree Core

      if (@updating_params[:order][:payments_attributes])
        # Start changed code
        payment_method = Spree::PaymentMethod.find(@updating_params[:order][:payments_attributes].first[:payment_method_id])

        if self.initial_payment_total != self.item_total && payment_method.respond_to?(:recurring_payment_method)
          # initial payment specified and payment method supports recurring
          @updating_params[:order][:payments_attributes] << @updating_params[:order][:payments_attributes].first.clone
          @updating_params[:order][:payments_attributes].first[:amount] = self.initial_payment_total
          @updating_params[:order][:payments_attributes].last[:amount] = (self.total - self.initial_payment_total)
          @updating_params[:order][:payments_attributes].last[:payment_method_id] = payment_method.recurring_payment_method.id
          # End Changed Code
        else
          # From Spree Core
          @updating_params[:order][:payments_attributes].first[:amount] = self.total
          # End Spree Core
        end
      end
    end
  end
end
