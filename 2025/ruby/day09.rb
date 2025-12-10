require_relative 'day'

class Day09 < Day # >

  # @example
  #   day.part1 #=> 50
  def part1
    input
      .split("\n")
      .map { |line| line.split(",").map(&:to_i) }
      .combination(2) # every pair of opposite corners
      .map { |opposite_corners|
        opposite_corners
          .transpose
          .map { |side_ends| (side_ends.reduce(&:-).abs + 1) } # length and width, inclusive of the start tile
          .reduce(&:*) # compute area
      }
      .max
  end

  # @example
  #   day.part2
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day09-example-input.txt")
end
