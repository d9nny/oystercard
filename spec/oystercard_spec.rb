require 'oystercard'

describe Oystercard do
  let(:waterloo) {double :waterloo}
  subject(:oystercard) {described_class.new}
  subject(:card_with_credit) {described_class.new(20)}

  context "On Initialise it" do
    it 'tests starting balance is zero' do
      expect(oystercard.balance).to eq(0)
    end
  end

  context "Topping up it" do
    it "top's up oystercard balance" do
    	expect(oystercard.top_up(10)).to eq (10)
    end
    it 'raises error if top up exceeds limit' do
      expect{oystercard.top_up(Oystercard::TOP_UP_LIMIT+1)}.to raise_error "Top up limit #{Oystercard::TOP_UP_LIMIT} exceeded"
    end
  end

  context "Touching in" do
    it 'raises an error when balance is smaller than minimum fair' do
    	expect{oystercard.touch_in(waterloo)}.to raise_error "Insufficient funds"
    end
  end

  before(:each) do
    card_with_credit.touch_in(waterloo)
  end
  
  context "Touching out" do
    it 'reduces balance by MIN_FARE' do
      expect{card_with_credit.touch_out(waterloo)}.to change{card_with_credit.balance}.by(-Oystercard::MIN_FARE)
    end
  end
end