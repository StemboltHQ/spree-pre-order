module Spree
  module Gateway::GlobalCollectRecurring
    class Base < Gateway
      preference :merchant_id, :string

      attr_accessible :preferred_merchant_id

      def provider_class
        ActiveMerchant::Billing::GlobalCollectGateway
      end

      # Stolen from active merchant
      def format_order_id order_id
        order_id = order_id.to_s.gsub(/-.*/, '')
        order_id.gsub(/[^\d]/, '')[0...10]
      end

      # disable normal payment methods
      undef_method :authorize
      undef_method :purchase
      undef_method :credit
      undef_method :capture
    end
    class Initial < Base
      def purchase money, creditcard, options
        options[:order_id] = format_order_id(options[:order_id])
        provider.multiple_initial_purchase(money, creditcard, options)
      end

      def auto_capture?
        true
      end

      def recurring_payment_method
        Spree::PaymentMethod.where(type: "Spree::Gateway::GlobalCollectRecurring::Additional").first!
      end
    end
    class Additional < Base
      # capture is the option presented from the spree admin payment interface
      def capture money, creditcard, options
        order_id = format_order_id(options.fetch(:order_id))
        order_status = provider.status(order_id)
        last_effort_id = Integer(order_status.params['STATUS']['EFFORTID'], 10)
        raise "need to make an initial payment before additional variable_recurring payments" unless last_effort_id > 0

        options = options.merge(
          order_id: order_id,
          effort_id: (last_effort_id + 1)
          )

        provider.multiple_append_purchase(money, options)
      end

      def actions
        [:capture]
      end
      def can_capture
        ['checkout', 'pending'].include?(payment.state)
      end
      def payment_source_class
        nil
      end

      def source_required?
        # using existing stored CC
        false
      end

      def auto_capture?
        false
      end
    end
  end
end

