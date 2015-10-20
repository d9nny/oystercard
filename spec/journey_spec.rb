require 'journey'

describe Journey do

  context 'start' do
    it {is_expected.to respond_to(:start)}
  end

  context 'finish' do
    it {is_expected.to respond_to(:finish)}
  end

end