require_relative 'day'

class Day03 < Day # >

  def setup
    @symbol_coords = []
    @schematic = Grid.new(input)

    @schematic.parse do |coords, content|
      @symbol_coords << coords unless content.match(/^(\d|\.)/)
    end

    @symbol_part_nos = @symbol_coords
                          .map { |symbol_coord|
                            [
                              @schematic.at(symbol_coord),
                              @schematic
                                .adjacent_to(symbol_coord)
                                .select { @schematic.at(_1).match(/\d/) }

                            ]
                          }
                          .map { |symbol, coords| [symbol, @schematic.find_numbers_from(coords)] }
  end

  # @example
  #   day.part1 #=> 4361
  def part1
    setup
    @symbol_part_nos
      .map { |_symbol, part_nos| part_nos }
      .flatten
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 467835
  def part2
    setup
    @symbol_part_nos
      .select { |symbol, part_nos| symbol == "*" && part_nos.count == 2 }
      .map { |_symbol, part_nos| part_nos.reduce(&:*) }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = <<~INPUT
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  INPUT
end

class Grid
  include Enumerable

  attr_writer :to_s_proc
  DEFAULT_TO_S_PROC = proc { |value| value.to_s }

  def initialize(input)
    @input = input
    @the_grid = Hash.new { |(r,c)| raise "No data loaded." }
  end

  def each
    @the_grid.each { |coords, value| yield coords, value }
  end

  # @example
  #   grid = new(Day03::EXAMPLE_INPUT)
  #   grid.at([0,0])       #=> raise "No data loaded."
  #   grid.parse
  #   grid.at([0,0])       #=> "4"
  #   grid.at([-100,-100]) #=> raise KeyError, "Coordinates not found on grid: [-100, -100]"
  def at(coords)
    @the_grid[coords]
  end

  # @example
  #   grid = new(Day03::EXAMPLE_INPUT)
  #   grid.parse
  #   grid.find_numbers_from([[0, 2], [2, 2], [2, 3]]) #=> [467, 35]
  def find_numbers_from(coords)
    seen = []
    coords
      .map { |row, column|
        next if seen.include?([row, column])

        seen << [row, column]
        digit_string = at([row, column])

        (column-1).downto(@column_bounds.min).each do |c|
          seen << [row, c]
          check = at([row, c])
          if check.match?(/\d/)
            digit_string = check + digit_string
          else
            break
          end
        end
        (column+1).upto(@column_bounds.max).each do |c|
          seen << [row, c]
          check = at([row, c])
          if check.match?(/\d/)
            digit_string = digit_string + check
          else
            break
          end
        end

        digit_string.to_i
      }
      .compact
  end

  ADJACENT_OFFSETS = [-1, -1, 0, 1, 1].permutation(2).to_a.uniq

  # @example
  #   grid = new(Day03::EXAMPLE_INPUT)
  #   grid.at([0,0])       #=> raise "No data loaded."
  #   grid.parse
  #   grid.adjacent_to([1,3]) #=> [[0, 2], [0, 3], [0, 4], [1, 2], [1, 4], [2, 2], [2, 3], [2, 4]]
  def adjacent_to(coords)
    ADJACENT_OFFSETS.map{ |offset|
      coords
        .zip(offset)
        .map {|p| p.reduce(&:+)}
    }
    .select { |neighbor| @the_grid.has_key?(neighbor) }
  end

  def parse
    @input
      .split("\n")
      .map { |line| line.chars }
      .each_with_index do |row, r|
        row.each_with_index do |char, c|
          @the_grid[[r,c]] = char
          yield [r,c], char if block_given?
        end
      end

    @the_grid.default_proc = proc {|_hash, key| raise KeyError, "Coordinates not found on grid: #{key}"}

    @row_bounds,
    @column_bounds = @the_grid
                      .keys
                      .transpose
                      .map{ |dimension| Range.new(*dimension.minmax) }

    self
  end
end
