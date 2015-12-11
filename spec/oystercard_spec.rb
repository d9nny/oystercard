require 'oystercard'

describe OysterCard do
  
  let(:log) {double :log, outstanding_charges: 1, in_journey?: true,
                            start_journey: :journey, exit_journey: 1, outstanding_charges: 6}
  let(:station) { double :station, name: :old_street, zone: 2}
  subject(:oystercard) { described_class.new(log) }

  describe 'initialization' do
    it 'has a default balance of 0' do
      expect(oystercard.balance).to eq 0
    end

    it 'creates a journey log object' do
      expect(oystercard.log).to eq log
    end
  end

  describe '#top_up' do
    it 'the balance can be topped up' do
      expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
    end

    it 'has a maximum balance' do
      expect{ oystercard.top_up(OysterCard::MAX_BALANCE) }.to raise_error("The maximum balance is #{OysterCard::MAX_BALANCE}")
    end
  end

  describe '#touch_in' do

    it 'raises an error if min funds not available' do
      expect { oystercard.touch_in(station) }.to raise_error "min funds not available"
    end

    it 'responds to log.start_journey' do
      oystercard.top_up 10
      expect(log).to receive(:start_journey)
      oystercard.touch_in(station)
    end

    it "deducts penalty fare when user doesn't previously touch out" do
      oystercard.top_up 10  
      oystercard.touch_in(station)
      expect{ oystercard.touch_in(station) }.to change { oystercard.balance }.by -6
    end
  end

  describe '#touch_out' do
    before(:each) do
      oystercard.top_up(10)
      oystercard.touch_in(station)
    end

    it 'responds to log.exit_journey' do
      oystercard.touch_out(station)
    end

    it 'deducts the fare on touch out' do
      expect{ oystercard.touch_out(station) }.to change { oystercard.balance }.by -OysterCard::MIN_BALANCE
    end
  end
end











