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
                             :total => 49.99,
                             :preorder_total => preorder_total,
                             :coupon_code => nil).as_null_object
  end

  before do
    controller.stub :spree_current_user => user
    controller.stub(:check_authorization) { true }
    controller.stub(:current_order) { order }
    controller.stub(:params) { params }
  end

  let(:preorder_total) { 0 }

  describe ".object_params" do
    describe 'payments_attributes' do
      let(:params) { { order: order_attributes  } }
      let(:order_attributes) { { payments_attributes: payments_attributes } }
      let(:payments_attributes) { [ { payment_method_id: payment_method_initial.id, amount: 20 } ] }
      let(:payment_method_initial) { create :payment_method, type: "Spree::Gateway::GlobalCollectRecurring::Initial" }
      let!(:payment_method_additional) { create :payment_method, type: "Spree::Gateway::GlobalCollectRecurring::Additional" }

      context 'when pre-order total is 0' do
        it 'updates the payments_attributes amount' do
          spree_post :update
          payments_attributes.first[:amount].should == 49.99
        end
      end

      context 'when pre-order total is > 0' do
        let(:preorder_total) { 10 }

        it 'creates a payment for the pre-order' do
          spree_post :update
          payments_attributes.first[:amount].should == 10
        end

        it 'creates a payment for the remaining price' do
          spree_post :update
          payments_attributes.last[:amount].should == 39.99
        end
      end
    end
  end
end
