require 'spec_helper'

describe Spree::LineItem do
  let(:line_item) { build :line_item, variant: variant, quantity: 3 }
  let(:variant) { create :variant }

  describe '.initial_payment_amount' do
    subject { line_item.initial_payment_amount }

    context "when there is a preorder_amount" do
      before { Spree::PreorderPrice.create! price_id: variant.default_price.id, amount: 10 }
      it { should == 30 }
    end

    context "when there is not a preorder amount" do
      let(:preorder_amount) { nil }
      it { should == 59.97 }
    end
  end
end
