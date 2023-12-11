require_relative 'day'
require_relative 'grid'

class Day11 < Day # >

  # @example
  #   day.part1 #=> 374
  def part1
    universe = CosmicExpansion.new(input)

    universe
      .galaxies
      .combination(2)
      .map { |here, there| universe.distance_between(here, there) }
      .reduce(&:+)
  end

  # @example
  # day.part2 #=> 'how are you'
  def part2
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
  attr_reader :galaxies

  def initialize(input)
    @input = input
    @galaxies = []
    @grid =
      Grid.new(
        expand_cosmically(
          scan(input)
        )
      )
    @grid.parse do |coords, value|
      galaxies << coords if value == GALAXY
    end
  end

  EMPTY_SPACE = '.'
  GALAXY = '#'

  def distance_between(here, there)
    @grid.manhattan_distance(here, there)
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

  # @example
  #  scanned_image = day.scan(Day11::EXAMPLE_INPUT)
  #  input_expanded = day.expand_cosmically(scanned_image)
  #  input_expanded #=> day.scan(Day11::EXPANDED_INPUT)
  def expand_cosmically(scanned_image)
    # dupe empty-space rows
    expanded_rows = []
    scanned_image
      .each do |row|
        n = row.all?(EMPTY_SPACE) ? 2 : 1
        n.times { expanded_rows << row }
      end

    # pivot the table, dupe empty-space columns
    expanded_columns = []
    expanded_rows
      .transpose
      .each do |column|
        n = column.all?(EMPTY_SPACE) ? 2 : 1
        n.times { expanded_columns << column }
      end

    # pivot things back around to original orientation
    # gotta get rid of this entirely for part 2, though
    3.times { expanded_columns = expanded_columns.transpose }
    expanded_columns
  end
end
