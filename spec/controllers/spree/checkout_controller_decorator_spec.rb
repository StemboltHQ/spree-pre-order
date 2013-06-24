require 'spec_helper'

describe Spree::CheckoutController do

  let(:user) { stub_model Spree::LegacyUser }
  let(:order) do
    mock_model(Spree::Order, :checkout_allowed? => true,
                             :user => user,
                             :email => nil,
                             :completed? => false,
                             :update_attributes => true,
                             :payment? => true,
                             :insufficient_stock_lines => [],
                             :item_total => 49.99,
                             :total => 54.99,
                             :initial_payment_total => initial_payment_total,
                             :coupon_code => nil).as_null_object
  end

  before do
    controller.stub :spree_current_user => user
    controller.stub(:check_authorization) { true }
    controller.stub(:current_order) { order }
    controller.stub(:params) { params }
  end

  let(:initial_payment_total) { 0 }

  describe ".object_params" do
    describe 'payments_attributes' do
      let(:params) { { order: order_attributes  } }
      let(:order_attributes) { { payments_attributes: payments_attributes } }
      let(:payments_attributes) { [ { payment_method_id: payment_method_initial.id, amount: 20 } ] }
      let(:payment_method_initial) { create :payment_method, type: "Spree::Gateway::GlobalCollectRecurring::Initial" }
      let!(:payment_method_additional) { create :payment_method, type: "Spree::Gateway::GlobalCollectRecurring::Additional" }

      before { spree_post :update }
      subject { payments_attributes }

      context 'when initial payment total matches the order item total' do
        let(:initial_payment_total) { 49.99 }
        its(:count) { should == 1 }

        it 'updates the payments_attributes amount' do
          payments_attributes.first[:amount].should == 54.99
        end
      end

      context 'when payment method doesnt support recurring' do
        let(:payment_method_initial) { create :payment_method, type: "Spree::PaymentMethod::Check" }
        let(:initial_payment_total) { 10 }
        its(:count) { should == 1 }

        it 'updates the payments_attributes amount' do
          payments_attributes.first[:amount].should == 54.99
        end
      end

      context 'when initial payment total is > 0, but less than the order total' do
        let(:initial_payment_total) { 10 }

        its(:count) { should == 2 }

        it 'creates a payment for the initial payment' do
          payments_attributes.first[:amount].should == 10
        end

        it 'creates a payment for the remaining price' do
          payments_attributes.last[:amount].should == 44.99
        end
      end
    end
  end
end
