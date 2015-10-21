require_relative 'station'
require_relative 'journey'

class Oystercard

   attr_reader :balance, :journey, :penalty_fare

  TOP_UP_LIMIT = 90
  MIN_FARE = 1
  PENALTY_FARE = 6

  def initialize (journey: Journey.new)
    @balance = 0
    @journey = journey
  end

  def top_up(amount)
    ((@balance + amount) > TOP_UP_LIMIT) ? (raise "Top up limit #{TOP_UP_LIMIT} exceeded") : (@balance += amount)
  end

  def touch_in(station)
    raise "Insufficient funds" if @balance < 1
    deduct(PENALTY_FARE) if journey.traveling?
    journey.start(station) 
  end

  def touch_out(station)
    journey.traveling? ? deduct : deduct(PENALTY_FARE)
    journey.finish(station)
  end

  private

  def deduct (fare=MIN_FARE)
    @balance -= fare
  end
end