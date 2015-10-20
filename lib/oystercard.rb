require_relative 'station'
require_relative 'journey'

class Oystercard

   attr_reader :balance, :journey, :penalty_fare

  TOP_UP_LIMIT = 90
  MIN_FARE = 1
  PENALTY_FARE = 6

  def initialize (balance = 0, journey: Journey.new)
    @balance = balance
    @journey = journey
  end

  def top_up(amount)
    ((@balance + amount) > TOP_UP_LIMIT) ? (raise "Top up limit #{TOP_UP_LIMIT} exceeded") : (@balance += amount)
  end

  def touch_in(station)
    raise "Insufficient funds" if @balance < 1
    if journey.state?
      journey.start(station)
    else
      journey.start(station)
      deduct(PENALTY_FARE)
    end
    balance
  end

  def touch_out(station)
    if journey.state?
      deduct
    else
      deduct(PENALTY_FARE)
    end
    journey.finish(station)
    balance
  end

  private

  def deduct (fare=MIN_FARE)
    @balance -= fare
  end

end