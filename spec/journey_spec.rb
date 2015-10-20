require 'journey'

describe Journey do
	let(:waterloo) {double :waterloo}
  let(:euston) {double :euston}
  subject(:journey) {described_class.new}

  context "testing doubles" do
    it 'stores a value station' do
      journey.start(waterloo)
      expect(journey.entry_station).to eq waterloo
    end
    it 'stores a value station' do
      journey.start(euston)
      expect(journey.entry_station).to eq euston
    end
  end

 	context "On Initialise it" do
    it 'creates an empty journey history' do
      expect(journey.history).to be_empty
    end
  end

  before(:each) do
    journey.start(waterloo)
  end

	context "On starting a journey it" do
    it 'changes status of journey to traveling' do
      expect(journey.traveling?).to eq true
    end
    it 'records the start station and zone' do
      expect(journey.entry_station).to eq waterloo
    end
	end

	context "On finishing a journey it" do
		before(:each) do
    	journey.finish(euston)
 		end
		it 'changes status of journey to not traveling' do
      expect(journey.traveling?).to eq false
    end
    it 'changes the entry station to nil on touch out' do
      expect(journey.entry_station).to eq nil
    end
    it 'makes a record of journey' do
      expect(journey.history).to eq ({waterloo=>euston})
    end
  end

  context "In Journey" do
    it 'tells user if they are currently traveling' do
      expect(journey.traveling?).to eq true
    end
  end
end