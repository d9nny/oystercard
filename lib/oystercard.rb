require_relative 'station'
require_relative 'journey'

class Oystercard

   attr_reader :balance, :journey, :penalty_fare, :history

  TOP_UP_LIMIT = 90
  MIN_BALANCE = 1

  def initialize (journey: Journey.new)
    @balance = 0
    @journey = journey
    @history = []
  end

  def top_up(amount)
    ((@balance + amount) > TOP_UP_LIMIT) ? (raise "Top up limit #{TOP_UP_LIMIT} exceeded") : (@balance += amount)
  end

  def touch_in(station)
    raise "Insufficient funds" if @balance < MIN_BALANCE
    deduct if journey.traveling?
    journey.start(station) 
  end

  def touch_out(station)
    deduct
    journey.finish(station)
    history << journey.record
  end

  private

  def deduct 
    @balance -= journey.fare
  end
end