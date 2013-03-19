require 'spec_helper'

describe Spree::PreorderPrice do
  let(:variant) { create :variant }
  let(:price) { variant.default_price }
  let(:preorder_price) { Spree::PreorderPrice.new amount: 5, price_id: price.id }

  describe '.money' do
    subject { preorder_price.money }
    it { should be_a(Spree::Money) }
    specify { subject.to_s.should == "$5.00" }
  end
end
