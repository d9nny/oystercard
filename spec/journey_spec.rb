require 'journey'

describe Journey do
  let(:entry_station) {double :station}
  let(:entry_station2) {double :station }
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
    it 'sets the fare to the penalty fare if starting twice' do
      journey.start(entry_station)
      expect(journey.fare).to eq Journey::PENALTY_FARE
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
    it 'expects a journey to be complete' do
      expect(journey).to be_complete
    end
    it 'returns the minimum fare for a complete journey' do
      expect(journey.fare).to eq Journey::MIN_FARE
    end
  end

  context "completing a journey after an incomplete one" do
    it 'records the new entry station' do
      journey.start(entry_station)
      journey.start(entry_station2)
      expect(journey.entry_station).to eq entry_station2
    end
  end
end
