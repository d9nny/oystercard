require 'log'

describe Log do 

  subject(:log) { described_class.new }
  let(:journey) {double :journey, entry_station: :old_street, pass_entry: :old_street, exit_station: :baker_street, pass_exit: :baker_street, fare: 1}
  let(:part_journey) {double :part_journey, entry_station: :old_street, pass_entry: :old_street, exit_station: nil, pass_exit: nil, fare: 1}
  let(:station) { double :station, name: :old_street, zone: 2}

  before(:each) do
      allow(journey).to receive(:start)
      allow(journey).to receive(:finish)
      allow(part_journey).to receive(:start)
    end

  describe 'initialization' do
    it 'has a default journey of nil' do 
      expect(log.current_journey).to be_nil
    end

    it 'the list of journeys is empty' do 
      expect(log.journeys).to be_empty
    end
  end

  describe '#start_journey' do
    it 'updates @journey when journey started' do
      log.start_journey(station, journey)
      expect(log.current_journey).to eq journey
    end
  end

  describe '#exit_journey' do
    before(:each) do
      log.start_journey(station, journey)
    end

    it 'adds multiple journeys to @journeys history' do
      log.exit_journey(station)
      log.start_journey(station, journey)
      log.exit_journey(station)
      expect(log.journeys.length).to eq 2
    end

    it 'updates @journeys when touched out' do
      expect { log.exit_journey(station) }.to change{ log.journeys }.to [journey]
    end
  end

  context '#outstanding_charges'do
    it "records the journey if user doesn't previously touch out" do #
      log.start_journey(station, part_journey)
      log.outstanding_charges
      expect(log.journeys).to include part_journey
    end
    it 'it reassigns journey from a journey object back to nil' do
      log.exit_journey(station)
      expect(log.current_journey).to eq nil
    end
    it 'is expected to return the fare' do 
      log.start_journey(station, journey)
      expect(log.outstanding_charges).to eq 1
    end
  end
end