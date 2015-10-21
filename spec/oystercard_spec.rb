require 'oystercard'

describe Oystercard do
  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  let(:this_journey) {{:entry_station => entry_station, :exit_station => exit_station }}
  let(:journey) {double :journey}
  subject(:oystercard) {described_class.new(journey: journey)}

  context "On Initialise it" do
    it 'tests starting balance is zero' do
      expect(oystercard.balance).to eq(0)
    end
    it 'creates an empty history record' do
      expect(oystercard.history).to be_empty
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
      expect{oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds"
    end
  end

  context "with credit - " do
    let(:top_up_value) {20}
    before(:each) do
      oystercard.top_up(top_up_value)
    end
    context "Touching in " do
      it "deducts the penatly fair when user doesn't touch out" do
        allow(journey).to receive(:traveling?).and_return(false)
        allow(journey).to receive(:fare).and_return(Journey::PENALTY_FARE)
        allow(journey).to receive(:start)
        oystercard.touch_in(entry_station)
        allow(journey).to receive(:traveling?).and_return(true)
        oystercard.touch_in(entry_station)
        expect(oystercard.balance).to eq (top_up_value - Journey::PENALTY_FARE)
      end
    end

    context "Touching out" do
      before(:each) do
        allow(journey).to receive(:finish)
        allow(journey).to receive(:record).and_return(this_journey)
        allow(journey).to receive(:traveling?).and_return(true)
        allow(journey).to receive(:start)
        allow(journey).to receive(:fare).and_return(Journey::MIN_FARE)
      end
      it "deducts the penatly fair when user doesn't touch in" do
        oystercard.touch_out(entry_station)
        allow(journey).to receive(:fare).and_return(Journey::PENALTY_FARE)
        allow(journey).to receive(:traveling?).and_return(false)
        oystercard.touch_out(entry_station)
        expect(oystercard.balance).to eq (top_up_value - (Journey::PENALTY_FARE + Journey::MIN_FARE))
      end
      it 'reduces balance by MIN_FARE' do

        oystercard.touch_in(entry_station)
        expect{oystercard.touch_out(entry_station)}.to change{oystercard.balance}.by(-Journey::MIN_FARE)
      end
      it 'records the journey history' do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.history.include?(this_journey)).to be true
      end
    end
  end
end
