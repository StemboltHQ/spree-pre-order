require 'spec_helper'

describe Spree::PreorderPrice do
  let(:price) { mock_model Spree::Price, currency: 'USD' }
  let(:preorder_price) { Spree::PreorderPrice.new amount: 5 }
  before { preorder_price.price = price }

  describe '.money' do
    subject { preorder_price.money }
    it { should be_a(Spree::Money) }
    specify { subject.to_s.should == "$5.00" }
  end
end
