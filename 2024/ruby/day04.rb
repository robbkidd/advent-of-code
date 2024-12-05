require_relative 'day'
require_relative 'grid'

class Day04 < Day # >

  # @example
  #   day.part1 #=> 18
  def part1
    exes = []
    word_search =
      Grid.new(input, raise_on_out_of_bounds: false)
        .parse do |coords, char|
          exes << coords if char == 'X'
        end

    exes
      .map { |x_location|
        IN_ALL_DIRECTIONS.map { |offset|
          (1..3).each_with_object([x_location]) { |step, xmas_check|
            xmas_check << step_in_direction(x_location, offset.map { |d| d * step })
          }
        }
        .map {|maybe_xmas| maybe_xmas.map { |l| word_search.at(l)}.join }
        .keep_if { _1 == "XMAS" }
      }
      .flatten
      .count
  end

  # @example
  #   IN_ALL_DIRECTIONS #=> [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  IN_ALL_DIRECTIONS = [-1, -1, 0, 1, 1].permutation(2).to_a.uniq.freeze

  # @example
  #   day.part2 #=> 9
  def part2
    ays = []
    word_search =
      Grid.new(input)
        .parse do |coords, char|
          ays << coords if char == 'A'
        end

    ays
      .keep_if { |a_location|
        begin
          ["M", "S"] == [ word_search.at(step_in_direction(a_location, [-1,-1])),
                          word_search.at(step_in_direction(a_location, [ 1, 1])) ].sort &&
            ["M", "S"] == [ word_search.at(step_in_direction(a_location, [-1, 1])),
                            word_search.at(step_in_direction(a_location, [ 1,-1])) ].sort
        rescue Grid::OutOfBounds
          false
        end
      }
      .count
  end

  # @example
  #   day.step_in_direction([3,5], [-1,1]) #=> [2,6]
  def step_in_direction(location, vector)
    location
      .zip(vector)
      .map { |l| l.reduce(&:+) }
  end

  EXAMPLE_INPUT = File.read("../inputs/day04-example-input.txt")
end
