require_relative 'day'
require 'parallel'

class Day22 < Day # >
  attr_reader :buyers

  def initialize(*args)
    super
    @buyers =
      Parallel
        .map(input.scan(/\d+/)) { |initial_secret_number|
          Buyer.new(initial_secret_number.to_i)
        }
    puts "initialized" if ENV['DEBUG']
  end

  # @example
  #   day = Day22.new('1 10 100 2024')
  #   day.part1 #=> 37327623
  def part1
    puts "starting part1" if ENV['DEBUG']

    Parallel
      .map(buyers) { |buyer| buyer.secret_numbers.last }
      .reduce(&:+)
  end

  # @example
  #   day = Day22.new('1 2 3 2024')
  #   day.part2 #=> 23
  def part2
    puts "starting part2" if ENV['DEBUG']

    unique_sequences =
      buyers
        .inject(Set.new) { |unique_sequences, buyer|
          unique_sequences.merge(buyer.price_sequence_table.keys)
        }

    puts "unique_sequences: #{unique_sequences.count}" if ENV['DEBUG']

    Parallel
      .map(unique_sequences) { |sequence|
        buyers
          .inject(0) { |bananas, buyer|
            bananas += (buyer.price_sequence_table[sequence] || 0)
          }
      }
      .max
  end

  EXAMPLE_INPUT = File.read("../inputs/day22-example-input.txt")
end

class Buyer
  attr_reader :secret_numbers, :prices, :price_sequence_table

  # @example
  #  buyer = Buyer.new(1)
  #  buyer.secret_numbers.first #=> 1
  #  buyer.secret_numbers.last #=> 8685429
  #  buyer.prices.first #=> 1
  #  buyer.prices.last #=> 9
  def initialize(initial_secret_number)
    @secret_numbers = [initial_secret_number]
    @prices = [initial_secret_number % 10]
    @price_sequence_table = Hash.new
    generate_secret_numbers
    generate_sequence_lookup
  end

  # @example 1
  #   buyer = Buyer.new(1)
  #   buyer.secret_numbers.last #=> 8685429
  # @example 10
  #   buyer = Buyer.new(10)
  #   buyer.secret_numbers.last #=> 4700978
  # @example 100
  #   buyer = Buyer.new(100)
  #   buyer.secret_numbers.last #=> 15273692
  # @example 2024
  #   buyer = Buyer.new(2024)
  #   buyer.secret_numbers.last #=> 8667524
  def generate_secret_numbers(evolutions=2000)
    evolutions.times do
      secret_number = @secret_numbers.last
      secret_number = ((secret_number * 64) ^ secret_number) % 16777216
      secret_number = ((secret_number / 32).floor ^ secret_number) % 16777216
      secret_number = ((secret_number * 2048) ^ secret_number) % 16777216
      @secret_numbers << secret_number
      @prices << secret_number % 10
    end
  end

  # @example
  #  buyer = Buyer.new(123)
  #  buyer.price_changes.take(9) #=> [-3, 6, -1, -1, 0, 2, -2, 0, -2]
  #  buyer.price_changes.count #=> 2000
  def price_changes
    @prices.each_cons(2).map { |a, b| b - a }
  end

  # @example
  #   buyer = Buyer.new(1)
  #   buyer.price_sequence_table[ [-2,1,-1,3] ] #=> 7
  def generate_sequence_lookup
    price_changes.each_cons(4).with_index do |four_deltas, i|
      @price_sequence_table[four_deltas] ||= @prices[i + 4]
    end
  end

  def price_sequence_table
    generate_sequence_lookup if @price_sequence_table.empty?
    @price_sequence_table
  end
end
