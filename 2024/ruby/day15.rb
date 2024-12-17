require_relative 'day'
require_relative 'grid'

class Day15 < Day # >

  # @example
  #   day.part1 #=> 'hey'
  def part1
    map_input, moves_input = input.split("\n\n")

    map =
      Grid
        .new(map_input)
        .parse {|coords, value|
          start = coords if value == '@'
        }

    moves = moves_input.gsub("\n", '').split('')
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day15-example-input.txt")
  SMALLER_EXAMPLE = <<~EXAMPLE
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
  EXAMPLE
end
