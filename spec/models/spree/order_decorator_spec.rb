require 'spec_helper'

describe 'Spree::Order' do
  let(:order) { build :order, line_items: line_items }
  let(:line_items) { [mock_model(Spree::LineItem, preorder_amount: 1), mock_model(Spree::LineItem, preorder_amount: 2.50), mock_model(Spree::LineItem, preorder_amount: nil)] }

  describe '.preorder_total' do
    it 'returns the total for the preorder_amount for all line_items' do
      order.preorder_total.should == 3.50
    end
  end
end
