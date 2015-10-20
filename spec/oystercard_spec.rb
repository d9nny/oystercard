require 'oystercard'

describe Oystercard do
  let(:waterloo) {double :waterloo}
  let(:euston) {double :euston}
  subject(:oystercard) {described_class.new}
  subject(:card_with_credit) {described_class.new(20)}

  before(:each) do
    allow(waterloo).to receive(:zone).and_return(4)
    allow(euston).to receive(:zone).and_return(4)
  end

  context "testing doubles" do
    it 'stores a value station' do
      card_with_credit.touch_in(waterloo)
      expect(card_with_credit.entry_station).to eq [waterloo,4]
    end
    it 'stores a value station' do
      card_with_credit.touch_in(euston)
      expect(card_with_credit.entry_station).to eq [euston,4]
    end
  end

  context "On Initialise it" do
    it 'tests starting balance is zero' do
      expect(oystercard.balance).to eq(0)
    end

    it 'stores a value of journey list' do
      expect(oystercard.journey_list).to be_empty
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

  before(:each) do
    card_with_credit.touch_in(waterloo)
  end

  context "Touching in" do

    it 'changes status of journey to travelling' do
      expect(card_with_credit.in_journey?).to eq true
    end

    it 'raises an error when balance is smaller than minimum fair' do
    	expect{oystercard.touch_in}.to raise_error "Insufficient funds"
    end

    it 'records the touch in station and zone' do
      expect(card_with_credit.entry_station).to eq [waterloo, 4]
    end
  end

  context "Touching out" do

    before(:each) do
      card_with_credit.touch_out(euston)
    end

    it 'changes status of journey to not travelling' do
      expect(card_with_credit.in_journey?).to eq false
    end

    it 'touch_out reduces balance by MIN_FARE' do
      expect{card_with_credit.touch_out}.to change{subject.balance}.by(-Oystercard::MIN_FARE)
    end

    it 'changes the entry station to nil on touch out' do
      expect(card_with_credit.entry_station).to eq nil
    end

    it 'makes a record of journey' do
      expect(card_with_credit.journey_list).to eq ({[waterloo,4]=>euston})
    end
  end

  context "In Journey" do
    it 'tells user if they are currently travelling' do
      expect(card_with_credit.in_journey?).to eq true
    end
  end
end