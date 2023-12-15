require_relative 'day'

class Day14 < Day # >

  # @example
  #   day.part1 #=> 136
  def part1
    Platform
      .new(input)
      .tilt(:north)
      .total_load_on_north_beams
  end

  # @example 1_000_000_000 cycles
  #   day.part2 #=> 64
  def part2
    p = Platform.new(input)
    p.cycle(1_000_000_000)
    p.total_load_on_north_beams
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

  AFTER_1_CYCLE = <<~CYCLE
    .....#....
    ....#...O#
    ...OO##...
    .OO#......
    .....OOO#.
    .O#...O#.#
    ....O#....
    ......OOOO
    #...O###..
    #..OO#....
  CYCLE

  AFTER_2_CYCLES = <<~CYCLE
    .....#....
    ....#...O#
    .....##...
    ..O#......
    .....OOO#.
    .O#...O#.#
    ....O#...O
    .......OOO
    #..OO###..
    #.OOO#...O
  CYCLE

  AFTER_3_CYCLES = <<~CYCLE
    .....#....
    ....#...O#
    .....##...
    ..O#......
    .....OOO#.
    .O#...O#.#
    ....O#...O
    .......OOO
    #...O###.O
    #.OOO#...O
  CYCLE

end

class Platform
  require_relative 'grid'
  require 'matrix'

  ROUNDED = "O"
  CUBED = "#"
  EMPTY = "."

  attr_reader :rounded_rocks, :immovable_rocks, :grid, :states

  def initialize(input)
    @input = input
    @states = []
    @loop_length = 0
    @grid = Grid.new(input).parse
    @rows_max = @grid.row_bounds.max
  end

  # @example once
  #   p = new(Day14::EXAMPLE_INPUT)
  #   p.cycle
  #   p.to_s #=> Day14::AFTER_1_CYCLE
  # @example twice
  #   p = new(Day14::EXAMPLE_INPUT)
  #   p.cycle(2)
  #   p.to_s #=> Day14::AFTER_2_CYCLES
  # @example thrice
  #   p = new(Day14::EXAMPLE_INPUT)
  #   p.cycle(3)
  #   p.to_s #=> Day14::AFTER_3_CYCLES
  def cycle(iterations = 1)
    i = 0
    while i < iterations do
      [:north, :west, :south, :east].each { |direction| tilt(direction) }

      current_state = rounded_rocks

      if (seen_at = states.find_index(current_state)) && @loop_length == 0
        @loop_length = i - seen_at
        target_iter = (iterations - i) % @loop_length + 1
        rounded_rocks.each { |coords| grid.set(coords, EMPTY) }
        states[target_iter].each {|coords| grid.set(coords, ROUNDED) }
        break [i, target_iter, total_load_on_north_beams]
      else
        states << current_state
        i += 1
      end
    end
  end

  DIRECTIONS = {
    north: Vector[-1, 0],
    west:  Vector[ 0,-1],
    south: Vector[ 1, 0],
    east:  Vector[ 0, 1],
  }

  # @example 1_north
  #   p = new(Day14::EXAMPLE_INPUT)
  #   p.tilt(:north)
  #   p.to_s #=> Day14::FIRST_TILT_NORTH
  def tilt(direction)
    loop do
      things_are_moving = false
      rounded_rocks
        .each do |coords|
          move_to = (Vector[*coords] + DIRECTIONS[direction]).to_a
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
  #   new(Day14::EXAMPLE_INPUT).tilt(:north).total_load_on_north_beams #=> 136
  def total_load_on_north_beams
    rounded_rocks
      .map { |coords| @rows_max - coords[0] + 1 }
      .reduce(&:+)
  end

  def rounded_rocks
    grid.filter_map { |coords, value| coords if value == ROUNDED }
  end

  # @example
  #   new(Day14::EXAMPLE_INPUT).to_s #=> Day14::EXAMPLE_INPUT
  def to_s
    grid.to_s
  end
end
