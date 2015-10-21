require_relative 'station'

class Journey
  attr_reader :fare

  MIN_FARE = 1
  PENALTY_FARE = 6

  def initialize
    @record= {}
    @fare = PENALTY_FARE
  end

  def record
    @record.dup
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
    @fare = MIN_FARE if complete?
  end
  def complete?
    (@record.has_key?(:entry_station) &&
      @record.has_key?(:exit_station) && !@record.has_value?(nil))
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
