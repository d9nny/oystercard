class Oystercard

   attr_reader :balance, :entry_station

  TOP_UP_LIMIT = 90
  MIN_FARE = 1

  def initialize (balance = 0)
    @balance = balance
    @entry_station = nil
  end

  def top_up amount
    ((@balance + amount) > TOP_UP_LIMIT) ? (raise "Top up limit #{TOP_UP_LIMIT} exceeded") : (@balance += amount)
  end

  def touch_in(station = :station)
  	(@balance < 1) ? (raise "Insufficient funds" ): (@in_journey = true)
    @entry_station = station
  end

  def touch_out
    deduct
    @entry_station = nil
  end

  def in_journey?
    @entry_station != nil
  end

  private
  def deduct (fare=MIN_FARE)
    @balance -= fare
  end
end