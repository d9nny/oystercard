require 'station'

describe Station do
	let(:station) {described_class.new("waterloo", "4")}

	context 'On initialisation' do
		it 'creates a struct with name attribute' do
			expect(station.name).to eq "waterloo"
		end
		it 'creates a struct with `zone attribute' do
			expect(station.zone).to eq "4"
		end
	end

end