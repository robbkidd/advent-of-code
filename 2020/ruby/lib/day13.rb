class Day13
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    BusSchedule.new.solve_part1
  end

  def part2
    BusSchedule.new.gold_coin_contest
  end

  def self.example_input
    <<~EXAMPLE
      939
      7,13,x,x,59,x,31,19
    EXAMPLE
  end
end

class BusSchedule
  require 'prime'
  attr_reader :earliest_time, :busses

  def initialize(input = nil)
    time_in, busses_in = (input || File.read("../inputs/day13-input.txt")).split("\n")
    @earliest_time = time_in.to_i
    @busses = busses_in.split(",")
                       .each_with_index
                       .reject{ |bus, idx| bus == "x" }
                       .map{ |bus, idx| [ bus.to_i, idx ] }
  end

  def solve_part1
    next_bus = next_arriving_bus
    next_bus[:bus_id] * (next_bus[:arrival_time] - earliest_time)
  end

  def next_arriving_bus
    busses.map{ |(bus_id, _)|
      { bus_id: bus_id, 
        arrival_time: bus_id * (1 + (earliest_time / bus_id))
      }
    }.min_by{ |bus| bus[:arrival_time] }
  end

  def gold_coin_contest
    current_timestamp = 0
    timestamp_factors = busses.shift.first.prime_division.map(&:first)

    busses.each do |(bus, offset)|
      # The first bus will depart at t + 0 every t = bus * i. In fact, for any bus it's
      # true that once you find a valid t where t + offset = bus * i, the next
      # valid t for that bus is (t + bus).
      #
      # So you can skip all the ts inbetween.
      skip_factor = timestamp_factors.inject(&:*)

      # Find the next t for which [t + offset = bus * i].
      loop do
        minutes_to_departure = bus - (current_timestamp % bus)
        break if minutes_to_departure == offset % bus
        current_timestamp += skip_factor
      end

      # If all busses are prime numbers (they are in AoC), the prime-only
      # solution would be:
      #
      # timestamp_factors.push(bus)
      #
      # The general purpose solution looks like this:
      timestamp_factors.push(*bus.prime_division.map(&:first))
      timestamp_factors.uniq!
    end

    current_timestamp
  end
end