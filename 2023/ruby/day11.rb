require_relative 'day'
require_relative 'grid'

class Day11 < Day # >

  # @example
  #   day.part1 #=> 374
  def part1
    expanded_universe =
      Grid.new(
        expand_cosmically(
          scan(input)
        )
      )

    galaxies = []
    expanded_universe.parse do |coords, value|
      galaxies << coords if value == GALAXY
    end

    galaxies
      .combination(2)
      .map { |here, there| expanded_universe.manhattan_distance(here, there) }
      .reduce(&:+)
  end

  # @example
  # day.part2 #=> 'how are you'
  def part2
  end


  # @example
  #   simple_input = "...\n.#.\n...\n"
  #   day.scan(simple_input) #=> [[".",".","."],[".","#","."],[".",".","."]]
  def scan(image)
    image
      .split("\n")
      .map(&:chars)
  end

  EMPTY_SPACE = '.'
  GALAXY = '#'

  # @example
  #  scanned_image = day.scan(EXAMPLE_INPUT)
  #  input_expanded = day.expand_cosmically(scanned_image)
  #  input_expanded #=> day.scan(EXPANDED_INPUT)
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
    # unnecessary for computing distances, but wanted for
    # visualizing output
    3.times { expanded_columns = expanded_columns.transpose }
    expanded_columns
  end

  # @example simple input
  #   simple_input = "...\n.#.\n...\n"
  #   scanned_image = day.scan(simple_input)
  #   scanned_image #=> [[".",".","."],[".","#","."],[".",".","."]]
  #   day.display(scanned_image) #=> simple_input
  # @example example input
  #   scanned_image = day.scan(EXAMPLE_INPUT)
  #   day.display(scanned_image) #=> EXAMPLE_INPUT
  def display(scanned_image)
    scanned_image
      .map { |row| row.join('') }
      .join("\n") + "\n"
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
