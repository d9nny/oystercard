require_relative 'log'
require_relative 'station'

class OysterCard

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  attr_reader :balance, :log

  def initialize(log = Log.new)
    @log = log
    @balance = 0
  end

  def touch_in(station)
    raise "min funds not available" if balance < MIN_BALANCE
    deduct(log.outstanding_charges) if log.in_journey?
    log.start_journey(station)
  end

  def touch_out(station)
    deduct(log.exit_journey(station))
  end

  def top_up(amount)
    fail "The maximum balance is #{MAX_BALANCE}" if amount + balance >= MAX_BALANCE
    @balance += amount
  end

  private
  
  def deduct(amount)
    @balance -= amount
  end
end

