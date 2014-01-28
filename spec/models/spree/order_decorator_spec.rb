require 'spec_helper'

describe 'Spree::Order' do
  describe '.initial_payment_total' do
    let(:order) { build :order, line_items: line_items }
    let(:line_items) { [mock_model(Spree::LineItem, initial_payment_amount: 1), mock_model(Spree::LineItem, initial_payment_amount: 2.50), mock_model(Spree::LineItem, initial_payment_amount: nil)] }

    it 'returns the total for the initial_payment_amount for all line_items' do
      order.initial_payment_total.should == 3.50
    end
  end

  describe ".adjust_for_pre_order" do
    let!(:payment_method) { create :payment_method, type: "Spree::Gateway::GlobalCollectRecurring::Initial" }
    let!(:payment_method_additional) { create :payment_method, type: "Spree::Gateway::GlobalCollectRecurring::Additional" }
    let!(:order) { create :order, state: "payment" }
    let!(:line_item) { create :line_item, price: 19.99 }

    let(:params) do
      {
        order: {
          payments_attributes: [
            {
              payment_method_id: payment_method.id,
              amount: 19.99,
            }
          ]
        },
        without_protection: true
      }
    end

    before do
      order.line_items << line_item
      order.reload
      price = line_item.variant.price_in(order.currency)
      price.preorder_price = Spree::PreorderPrice.new(amount: 19.99)
    end

    subject { order.update_from_params(params) }

    context "when inital payment total matches the order item total" do
      before { subject }
      specify { order.payments.first.amount.should == order.total }
    end

    context "when the payment gateway doesn't support recurring payments" do
      let!(:payment_method) { create :payment_method }
      before { subject }
      specify { order.payments.first.amount.should == order.total }
    end

    context "when a preorder price of a line item is > 0, but less than the order total" do
      before do
        Spree::PreorderPrice.last.tap{|p| p.amount = 12}.save!
        subject
      end

      specify { order.payments.first.amount.to_s.should == "12.0" }
      specify { order.payments.last.amount.to_s.should == "7.99" }
      specify { order.payments.first.payment_method.id.should == payment_method.id }
      specify { order.payments.last.payment_method.id.should == payment_method_additional.id }
    end
  end
end
