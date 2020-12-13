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
  end

  def self.example_input
    <<~EXAMPLE
      939
      7,13,x,x,59,x,31,19
    EXAMPLE
  end
end

class BusSchedule
  attr_reader :earliest_time, :buses

  def initialize(input = nil)
    time_in, buses_in = (input || File.read("../inputs/day13-input.txt")).split("\n")
    @earliest_time = time_in.to_i
    @buses = buses_in.split(",")
                     .reject{|bus| bus == "x"}
                     .map(&:to_i)
  end

  def solve_part1
    next_bus = next_arriving_bus
    next_bus[:bus_id] * (next_bus[:arrival_time] - earliest_time)
  end

  def next_arriving_bus
    buses.map{ |bus|
      { bus_id: bus, 
        arrival_time: bus * (1 + (earliest_time / bus))
      }
    }.min_by{ |bus| bus[:arrival_time] }
  end
end