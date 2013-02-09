describe 'Spree::Variant' do
  let(:variant) { create :variant }

  describe '.preorder_price' do
    subject { variant.preorder_price('USD') }

    context "when variant is a normal product" do
      it { should be_nil }
    end

    context "when variant has a preorder_price" do
      before { Spree::Price.any_instance.stub(:preorder_price) { 5.99 } }
      it { should == 5.99 }
    end
  end
end
