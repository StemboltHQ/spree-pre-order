require 'spec_helper'

describe Spree::LineItem do
  let(:line_item) { build :line_item, variant: variant, quantity: 3 }
  let(:variant) { mock_model Spree::Variant, price_in: 80, preorder_amount: preorder_amount }

  describe '.initial_payment_amount' do
    subject { line_item.initial_payment_amount }

    context "when there is a preorder_amount" do
      let(:preorder_amount) { 10 }
      it { should == 30 }
    end

    context "when there is not a preorder amount" do
      let(:preorder_amount) { nil }
      it { should == 240 }
    end
  end
end
