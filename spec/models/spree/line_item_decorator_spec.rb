require 'spec_helper'

describe Spree::LineItem do
  let(:line_item) { build :line_item, variant: variant, quantity: 3 }
  let(:variant) { mock_model Spree::Variant, preorder_amount: 10 }

  describe '.preorder_amount' do
    subject { line_item.preorder_amount }
    it { should == 30 }
  end
end
