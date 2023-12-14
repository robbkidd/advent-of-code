require_relative 'day'

class Day14 < Day # >

  # @example
  #   day.part1 #=> 136
  def part1
    columns =
      input
        .split("\n")
        .map(&:chars)
        .transpose      # pivot so that each array is a column
        .reject {|column| !column.include?("O") } # don't bother with columns that don't have rounded rocks
        .map(&:join)    # make it a string again
        .map { |column|
          column
            .reverse              # north is now towards the end of the string
            .split("#", -1)       # find the stretches between cube rocks, keep trailing empties
            .map { |substring|
              substring.chars.sort.join # roll rocks within stretches
            }
            .join("#")                  # put the cubes back in

        }
        .map { |rolled_column|
              (0..rolled_column.length)
                .filter_map {|i| i+1 if rolled_column[i] == "O"}
                .reduce(&:+)
            }
        .reduce(&:+)
  end

  # example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
  INPUT
end
