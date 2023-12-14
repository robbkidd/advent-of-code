require_relative 'day'

class Day14 < Day # >

  # @example
  #   day.part1 #=> 136
  def part1
    Platform
      .new(input)
      .tilt
      .total_load_on_north_beams
  end

  # example 1_000_000_000 cycles
  #   day.part2 #=> 64
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

  FIRST_TILT_NORTH = <<~TILT
    OOOO.#.O..
    OO..#....#
    OO..O##..O
    O..#.OO...
    ........#.
    ..#....#.#
    ..O..#.O.O
    ..O.......
    #....###..
    #....#....
  TILT
end

class Platform
  require_relative 'grid'
  require 'matrix'

  ROUNDED = "O"
  CUBED = "#"
  EMPTY = "."

  attr_reader :rounded_rocks, :immovable_rocks, :grid

  def initialize(input)
    @input = input
    @grid = Grid.new(input).parse
    @rows_max = @grid.row_bounds.max
  end

  # @example
  #   p = new(Day14::EXAMPLE_INPUT)
  #   p.tilt
  #   p.to_s #=> Day14::FIRST_TILT_NORTH
  def tilt
    loop do
      things_are_moving = false
      rounded_rocks
        .each do |coords, rock|
          move_to = (Vector[*coords] + Vector[-1,0]).to_a
          if grid.cover?(move_to) && grid.at(move_to) == EMPTY
            grid.set(move_to, ROUNDED)
            grid.set(coords, EMPTY)
            things_are_moving = true
          end
        end
      break unless things_are_moving
    end
    self
  end

  # @example
  #   new(Day14::EXAMPLE_INPUT).tilt.total_load_on_north_beams #=> 136
  def total_load_on_north_beams
    rounded_rocks
      .map { |coords, _value| @rows_max - coords[0] + 1 }
      .reduce(&:+)
  end

  def rounded_rocks
    grid.select { |_coords, value| value == ROUNDED }
  end

  # @example
  #   new(Day14::EXAMPLE_INPUT).to_s #=> Day14::EXAMPLE_INPUT
  def to_s
    grid.to_s
  end
end
