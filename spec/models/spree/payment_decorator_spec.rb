require 'spec_helper'

describe Spree::Payment do
  let(:payment) { create :payment, order: order, source_id: nil }
  let(:order) { create :order }

  describe '.initial_payment' do
    subject { payment.initial_payment }
    context "when there is a payment from the same order with a source" do
      let!(:payment_with_source) { create :payment, order: order }
      it { should == payment_with_source }
    end

    context "when there is not a payment from the same order with a source" do
      it { should be_nil }
    end
  end

  describe '.steal_source_from_initial' do
    before { payment.steal_source_from_initial }

    context "when source is nil" do
      context "when a payment for this order with a source exists" do
        let!(:payment_with_source) { create :payment, order: order }

        it 'sets the source to the inital payment source' do
          payment.source == payment_with_source.source
        end
      end
    end
  end
end
