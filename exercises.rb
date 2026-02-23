# exercise 1
puts "=== ex 1 ===\n"
def score(number)
  if number >= 7
    :high
  elsif number >= 5
    :medium
  else
    :low
  end
end
    
[1e-1, 4.5, 5, 6.5, 7.5, 10_000].each do |scoreVal|
  puts score scoreVal
end

# exercise 2
puts "\n=== ex 2 ===\n"

def safe_divide(a, b)
  return nil unless a.is_a?(Numeric) && b.is_a?(Numeric)
  return nil if b.zero?
  
  (a/b).to_f rescue nil
end

[[1,0], [0,0], ['a', 2], [2, '0'], [1,2], [9,2], [1.0, 3], [10.0, 3.0], [1e-1, 1e-10]].each do |a,b|
  puts (safe_divide a,b) || 'nil'
end

# exercise 3
puts "\n=== ex 3 ===\n"

class User
  def initialize(name, email, active=false)
    @name = name
    @email = email
    @active = active
  end

  def to_s
    "#<#{@name} <#{@email}> - #{ @active ? "Active ✅" : "Disabled 🚫" }>"
  end

  def deactivate!
    @active = false
  end

  def active?
    @active
  end

  def email
    @email
  end
end

a = User.new("Bruno", "mail@mail.com")
puts a
b = User.new("Bruno2", "mail@mail2.com", true)
puts b
c = User.new("Bruno3", "mail@mail3.com", true)
c.deactivate!
puts c

# exercise 4
puts "\n=== ex 4 ===\n"

class CurrencyMismatchError < StandardError; end

class Money
  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount   = amount.freeze
    @currency = currency.freeze
  end

  def add(other)
    raise CurrencyMismatchError unless same_currency?(other)
    self.class.new(amount + other.amount, currency)
  end

  def ==(other)
    other.is_a?(Money) &&
      amount == other.amount &&
      currency == other.currency
  end

  def to_s
    "#{amount} #{currency}"
  end

  private

  def same_currency?(other)
    other.is_a?(Money) && other.currency == currency
  end
end

a = Money.new(100, "BRL")
b = Money.new(100, "BRL")
b = a.add(b)
puts b

c = Money.new(100, "USD")
d = Money.new(100, "BRL")
begin
  d = c.add(d)
rescue StandardError => e
  puts e.message
end

# exercise 5
puts "\n=== ex 5 ===\n"

def with_logging
  puts "Program is calling"
  begin
    yield
  ensure
    puts "Program finished"
  end
end

a = with_logging { 10 + 850 }
puts a

# exercise 6
puts "\n=== ex 6 ===\n"

users = [
  User.new("Bruno1", "mail@mail1.com"),
  User.new("BrunO2", "Mail@mail2.com", true),
  User.new("brUno3", "mAil@mail3.com"),
  User.new("Bruno4", "maIl@mail4.com", true),
  User.new("bruNo5", "maiL@mail5.com")
]

active_user_emails = 
  users
    .select(&:active?)
    .map { |user| user.email.upcase }

puts active_user_emails

# exercise 7
puts "\n=== ex 7 ===\n"

class IntegerParseError < RuntimeError
  attr_reader :value
  def initialize(val = nil)
    super("Non numeric value is not parseable to an Integer: '#{val}'")
  end
end


def parse_int(str)
  Integer(str, 10)
rescue ArgumentError, TypeError
  raise IntegerParseError, str
end

begin
  a = parse_int('1234567890')
  puts a
rescue => e
  puts e.message
end
begin
  a = parse_int('1234x890')
  puts a
rescue => e
  puts e.message
end
begin
  a = parse_int(1234567890)
  puts a
rescue => e
  puts e.message
end
begin # This one gets rounded
  a = parse_int('10.0')
  puts a
rescue => e
  puts e.message
end

# exercise 8
puts "\n=== ex 8 ===\n"

module Loggable
  extend self
  def timed
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
  ensure
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    puts "Execution took #{duration.round(4)} seconds"
  end
end

class Mamath
  include Loggable

  def add(a, b)
    timed { a + b }
  end
end


mm = Mamath.new()
val = mm.add(1293, 12852)
puts val

# exercise 9
puts "\n=== ex 9 ===\n"

method1 = -> { puts 'Hi from method 1' }
method2 = -> { puts 'Hello from method 2' }

config = { method1:, method2: }

class Magic
  def self.define_from(config)
    config.each do |name, block|
      define_method(name, &block)
    end
  end
end

Magic.define_from(config)
m = Magic.new

m.method1() if m.respond_to?(:method1, true)
m.method2() if m.respond_to?(:method2, true)
m.method3() if m.respond_to?(:method3, true)

# exercise 10
puts "\n=== ex 10 ===\n"

def definedMethod(*args)
  puts "I'm defined. Args: #{args.join(' ')}"
end

class Sender
  include Loggable
  def sentMethod(*args)
    puts "I'm sent. Args: #{args.join(' ')}"
  end
end

Loggable.timed { definedMethod('Hi', 'mister') }

s = Sender.new()
Loggable.timed { s.send(:sentMethod, 'Hi', 'miss') }

begin
  Loggable.timed { s.unexisting('Hi', 'no one') }
rescue => e
  puts e.message
end
