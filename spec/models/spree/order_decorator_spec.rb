require 'spec_helper'

describe 'Spree::Order' do
  let(:order) { build :order, line_items: [line_item] }
  let(:line_item) { build :line_item }

  describe '.preorder_total' do
    context "with normal orders" do
      it 'has a preorder_total of 0' do
        order.preorder_total.should == 0
      end
    end

    context "with a preorder" do
      before do
        Spree::Variant.any_instance.stub(:preorder_amount) { 4.99 }
      end
      it 'has a preorder_total from the variant' do
        order.preorder_total.should == 4.99
      end
    end
  end
end
