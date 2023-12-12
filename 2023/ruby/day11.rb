require_relative 'day'
require_relative 'grid'

class Day11 < Day # >

  # @example
  #   day.part1 #=> 374
  def part1
    @universe ||= CosmicExpansion.new(input)

    @universe
      .shortest_distances(expansion_rate: 2)
      .reduce(&:+)
  end

  # @example 2x
  #   universe = CosmicExpansion.new(Day11::EXAMPLE_INPUT)
  #   universe.shortest_distances(expansion_rate: 2).reduce(&:+) #=> 374
  # @example 10x
  #   universe = CosmicExpansion.new(Day11::EXAMPLE_INPUT)
  #   universe.shortest_distances(expansion_rate: 10).reduce(&:+) #=> 1030
  # @example 100x
  #   universe = CosmicExpansion.new(Day11::EXAMPLE_INPUT)
  #   universe.shortest_distances(expansion_rate: 100).reduce(&:+) #=> 8410
  def part2
    @universe ||= CosmicExpansion.new(input)

    @universe
      .shortest_distances(expansion_rate: 1_000_000)
      .reduce(&:+)
  end

  EXAMPLE_INPUT = <<~INPUT
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  INPUT

  EXPANDED_INPUT = <<~INPUT
    ....#........
    .........#...
    #............
    .............
    .............
    ........#....
    .#...........
    ............#
    .............
    .............
    .........#...
    #....#.......
  INPUT
end

class CosmicExpansion
  def initialize(input)
    @input = input
    @empty_rows = nil
    @empty_columns = nil
    @galaxies = []
    @occupied_rows = []
    @occupied_columns = []

    input
      .split("\n")
      .map(&:chars)
      .each_with_index do |row, r|
        row.each_with_index do |char, c|
          if char == '#'
            @occupied_rows << r
            @occupied_columns << c
            @galaxies << [r, c]
          end
        end
      end
  end


  def shortest_distances(expansion_rate: 1)
    expand_by(expansion_rate)
      .combination(2)
      .map { |here, there|
        # like in manhattan
        (here[0] - there[0]).abs + (here[1] - there[1]).abs
      }
  end

  def expand_by(expansion_rate)
    galaxies
      .map { |coords|
        row, column = coords
        [
          row + ((empty_rows.select{|r| r < row}).length * (expansion_rate-1)),         # -1 because the original row/column is
          column + ((empty_columns.select{|c| c < column}).length * (expansion_rate-1)) # already included in original coord
        ]
      }
  end

  def empty_rows
    @empty_rows ||= Range.new(*@occupied_rows.minmax).entries - @occupied_rows
  end

  def empty_columns
    @empty_columns ||= Range.new(*@occupied_columns.minmax).entries - @occupied_columns
  end

  def galaxies
    return @galaxies if @galaxies

    @galaxies = []
    @occupied_rows = []
    @occupied_columns = []

    @scanned_image
      .each_with_index do |row, r|
        row.each_with_index do |char, c|
          if char == GALAXY
            @occupied_rows << r
            @occupied_columns << c
            @galaxies << [r, c]
          end
        end
      end
    @galaxies
  end

  # @example
  #   simple_input = "...\n.#.\n...\n"
  #   universe = CosmicExpansion.new(simple_input)
  #   universe.scan(simple_input) #=> [[".",".","."],[".","#","."],[".",".","."]]
  def scan(image)
    image
      .split("\n")
      .map(&:chars)
  end
end
