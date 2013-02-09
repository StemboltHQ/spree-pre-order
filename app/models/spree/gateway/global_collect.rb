module Spree
  class Gateway::GlobalCollect < Gateway
    preference :merchant_id, :string
    preference :currency_code, :string, :default => 'CAD'

    attr_accessible :preferred_merchant_id, :preferred_currency_code

    def provider_class
      ActiveMerchant::Billing::GlobalCollectGateway
    end
  end
end
