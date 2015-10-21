require 'journey'

describe Journey do
  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  let(:this_journey) {{:entry_station => entry_station, :exit_station => exit_station }}
  subject(:journey) {described_class.new}

  context "On Initialise" do
    it 'creates an empty journey history' do
      expect(journey.record).to be_empty
    end
    it 'is not in a journey' do
      expect(journey.traveling?).to be false
    end
    it 'has a default penalty fare' do
    	expect(journey.fare).to eq Journey::PENALTY_FARE 
    end
  end

  context "On starting a journey it" do
    before(:each) do
      journey.start(entry_station)
    end
    it 'changes status of journey to traveling' do
      expect(journey.traveling?).to eq true
    end
    it 'records the start station and zone' do
      expect(journey.entry_station).to eq entry_station
    end
  end

  context "On finishing a complete journey it" do
    before(:each) do
      journey.start(entry_station)
      journey.finish(exit_station)
    end
    it 'changes status of journey to not traveling' do
      expect(journey.traveling?).to eq false
    end
    it 'stores the exit station on completion' do
      expect(journey.exit_station).to eq exit_station
    end
    it 'makes a record of a complete journey' do
      expect(journey.record).to eq (this_journey)
    end
  end
end
