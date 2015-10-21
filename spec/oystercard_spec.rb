require 'oystercard'

describe Oystercard do
  let(:waterloo) {double :waterloo}
  let(:journey) {double :journey}
  subject(:oystercard) {described_class.new(journey: journey)}

  context "On Initialise it" do
    it 'tests starting balance is zero' do
      expect(oystercard.balance).to eq(0)
    end
  end

  context "Topping it up" do
    it "top's up oystercard balance" do
      expect(oystercard.top_up(10)).to eq (10)
    end
    it 'raises error if top up exceeds limit' do
      expect{oystercard.top_up(Oystercard::TOP_UP_LIMIT+1)}.to raise_error "Top up limit #{Oystercard::TOP_UP_LIMIT} exceeded"
    end
  end

  context "Touching in without credit" do
    it 'raises an error when balance is smaller than minimum fair' do
      expect{oystercard.touch_in(waterloo)}.to raise_error "Insufficient funds"
    end
  end

  context "with credit - " do
    before(:each) do
      oystercard.top_up(20)
    end
    context "Touching in " do
      it "deducts the penatly fair when user doesn't touch out" do
        allow(journey).to receive(:traveling?).and_return(true)
        allow(journey).to receive(:start).and_return(true)
        oystercard.touch_in(waterloo)
        expect(oystercard.balance).to eq 14
      end
    end

    context "Touching out" do
      before(:each) do
        allow(journey).to receive(:finish).and_return(true)
      end
      it "deducts the penatly fair when user doesn't touch in" do
        allow(journey).to receive(:traveling?).and_return(false)
        oystercard.touch_out(waterloo)
        expect(oystercard.balance).to eq 14
      end
      it 'reduces balance by MIN_FARE' do
        allow(journey).to receive(:traveling?).and_return(true)
        allow(journey).to receive(:start).and_return(false)
        oystercard.touch_in(waterloo)
        expect{oystercard.touch_out(waterloo)}.to change{oystercard.balance}.by(-Oystercard::MIN_FARE)
      end
    end
  end
end
