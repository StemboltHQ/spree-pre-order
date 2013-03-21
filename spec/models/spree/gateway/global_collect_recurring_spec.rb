require 'spec_helper'

describe Spree::Gateway::GlobalCollectRecurring::Initial do
  it{ should be_auto_capture }

  describe 'provider' do
    its(:provider){ should be_a ActiveMerchant::Billing::GlobalCollectGateway }
    its(:provider){ should respond_to(:multiple_initial_purchase) }
  end

  describe 'purchase' do
    let(:provider){ double('provider') }
    let(:money){ double('money') }
    let(:cc){ double('cc') }
    let(:options){ {order_id: "r123-AB12NN11" } }
    before { subject.stub(provider: provider) }
    it "should call provider.multiple_initial_purchase" do
      provider.should_receive(:multiple_initial_purchase).with(money, cc, options)
      subject.purchase money, cc, options
    end
  end
end

describe Spree::Gateway::GlobalCollectRecurring::Additional do
  describe 'provider' do
    its(:provider){ should be_a ActiveMerchant::Billing::GlobalCollectGateway }
    its(:provider){ should respond_to(:multiple_append_purchase) }
  end

  describe 'capture' do
    let(:provider){ double('provider', status: status_response) }
    let(:money){ double('money') }

    # an activemerchant response
    let(:status_response){ double('Response', params: status_params) }
    let(:status_params){ {'STATUS' => {'EFFORTID' => '1'}} }

    before { subject.stub(provider: provider) }
    let(:options){ {order_id: "12345" } }

    it "should call multiple_append_purchase with the next available effort_id" do
      provider.should_receive(:multiple_append_purchase).with(money, hash_including(order_id: "12345", effort_id: 2))
      subject.capture money, nil, options
    end

    context 'without initial purchase' do
      let(:status_params){ {'STATUS' => {'EFFORTID' => '0'}} }
      it "shoud raise exception" do
        expect{
          subject.capture money, nil, options
        }.to raise_error
      end
    end
  end
end

