require_relative 'station'

class Journey
  attr_reader :entry_station, :history

  def initialize
    @entry_station = nil
    @history= {}
  end

  def start(station)
    @entry_station = station
  end

  def finish(station)
    @history[entry_station] = station
    @entry_station = nil
  end

  def traveling?
    @entry_station != nil
  end

end
