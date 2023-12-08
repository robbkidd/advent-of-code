require_relative "day"

class Day14 < Day
  # @example
  #   day.part1 #=> 24
  def part1
    @input
      .split("\n")
      .map do |line|
        line
          .split(" -> ")
          .map { |coords_str| coords_str.split(",").map(&:to_i) }
          .each_cons(2)
          .map do |wall_ends|
            wall_ends.transpose.map { |dim_ends| Range.new(*dim_ends) }
          end
      end
  end

  # @example
  #   day.part2
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
  INPUT
end
