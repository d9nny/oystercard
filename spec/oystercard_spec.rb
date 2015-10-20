require 'oystercard'

describe Oystercard do
  let(:waterloo) {double :waterloo}
  subject(:oystercard) {described_class.new}
  subject(:oystercard20) {described_class.new(20)}

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
    it 'changes status of journey to travelling' do
    	oystercard.top_up(Oystercard::MIN_FARE)
      oystercard.touch_in
      expect(oystercard.in_journey?).to eq true
    end
    it 'raises an error when balance is smaller than minimum fair' do
    	expect{oystercard.touch_in}.to raise_error "Insufficient funds"
    end
    it 'records the touch in station' do
      oystercard20.touch_in(waterloo)
      expect(oystercard20.entry_station).to eq waterloo
    end
  end

  context "Touching out" do
    it 'changes status of journey to not travelling' do
      oystercard20.touch_in
      oystercard20.touch_out
      expect(oystercard20.in_journey?).to eq false
    end
    it 'touch_out reduces balance by MIN_FARE' do
      expect{oystercard20.touch_out}.to change{subject.balance}.by(-Oystercard::MIN_FARE)
    end
    it 'changes the entry station to nil on touch out' do
      oystercard20.touch_in(waterloo)
      oystercard20.touch_out
      expect(oystercard20.entry_station).to eq nil
    end
  end
  context "In Journey" do
    it 'tells user if they are currently travelling' do
      oystercard20.touch_in
      expect(oystercard20.in_journey?).to eq true
    end
  end
end