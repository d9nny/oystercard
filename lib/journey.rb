require_relative 'station'

class Journey
  attr_reader  :record

  def initialize
    @record= {}
  end

  def entry_station
    record[:entry_station]
  end

  def exit_station
    record[:exit_station]
  end
  def start(station)
    @record[:entry_station] = station
  end

  def finish(station)
    @record[:exit_station] = station
  end

  def traveling?
    has_valid_entry_station? && !has_exit_station?
  end
  private
  def has_valid_entry_station?
    ( record.has_key? :entry_station ) && ( record[:entry_station] != nil )
  end
  def has_exit_station?
    ( record.has_key? :exit_station ) && ( record[:exit_station] != nil )
  end
end
