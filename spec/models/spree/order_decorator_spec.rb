require 'spec_helper'

describe 'Spree::Order' do
  let(:order) { build :order, line_items: line_items }
  let(:line_items) { [mock_model(Spree::LineItem, initial_payment_amount: 1), mock_model(Spree::LineItem, initial_payment_amount: 2.50), mock_model(Spree::LineItem, initial_payment_amount: nil)] }

  describe '.initial_payment_total' do
    it 'returns the total for the initial_payment_amount for all line_items' do
      order.initial_payment_total.should == 3.50
    end
  end
end
