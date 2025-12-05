require_relative 'day'

class Day01 < Day # >

  # @example
  #   day.part1 #=> 3
  def part1
    turn_results = [50]
    dial = 50
    parse_input.each do |rotation|
      dial = (dial + rotation) % 100
      turn_results << dial
    end
    turn_results
      .keep_if { _1 == 0 }
      .count
  end

  # @example
  #   day.part2 #=> 6
  def part2
    dial = 50
    passes = 0

    parse_input.each do |rotation|
      passes += case
                when rotation.positive? # turning right is straightforward
                  (dial + rotation) / 100
                when dial > rotation.abs # turning left but the negative turn is smaller than the current dial
                  0
                when dial == 0 # turning left when the dial is already at zero
                  rotation.abs / 100
                else # turning left when the negative turn is larger than current dial (we'll pass 0 at least once)
                  1 + (dial + rotation).abs / 100
                end
      dial = (dial + rotation) % 100
      puts [dial, passes].inspect
    end

    passes
  end

  # @example
  #   parsed = day.parse_input
  #   parsed.first #=> -68
  #   parsed.last #=> -82
  #   parsed[-2] #=> 14
  def parse_input
    @input
      .split("\n")
      .map { |line|
        dir, clicks = line[0], line[1..].to_i
        clicks *= -1 if dir == "L" # left (toward lower numbers)
        clicks
      }
  end

  EXAMPLE_INPUT = File.read("../inputs/day01-example-input.txt")
end
