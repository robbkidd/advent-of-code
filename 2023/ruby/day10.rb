require_relative 'day'
require_relative 'grid'
require_relative 'ugly_sweater'

class Day10 < Day # >
  include UglySweater
  # @example
  #   day.part1 #=> 4
  # @example more complex input
  #   day = Day10.new(MORE_COMPLEX_INPUT)
  #   day.part1 #=> 8
  def part1
    @pipe_maze = PipeMaze.new(input)
    @pipe_maze.loop_path.length / 2
  end

  # @example
  #   day = Day10.new(PART2_INPUT)
  #   day.part1
  #   day.part2 #=> 4
  # @example larger example
  #   day = Day10.new(PART2_LARGER_EXAMPLE)
  #   day.part1
  #   day.part2 #=> 8
  # @example junk example
  #   day = Day10.new(PART2_JUNK_EXAMPLE)
  #   day.part1
  #   day.part2 #=> 10
  def part2
    puts @pipe_maze.to_ugly_sweater
    @pipe_maze.inner_cells.length
  end

  EXAMPLE_INPUT = <<~INPUT
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
  INPUT

  MORE_COMPLEX_INPUT = <<~INPUT
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
  INPUT

  PART2_INPUT = <<~INPUT
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
  INPUT

  PART2_LARGER_EXAMPLE = <<~INPUT
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
  INPUT

  PART2_JUNK_EXAMPLE = <<~INPUT
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
  INPUT
end

class PipeMaze
  attr_reader :start

  # @example
  #   maze = PipeMaze.new(Day10::EXAMPLE_INPUT)
  #   maze.start #=> [1,1]
  def initialize(input)
    @input = input
    @start = nil
    @grid = Grid.new(input)
    @grid.parse { |coords, value|
      @start = coords if value == "S"
      @grid.set(coords, value.tr('|\-LJ7F.S', "│─└┘┐┌░╳"))
    }
  end

  def loop_path
    @loop_path ||= find_loop
  end

  def find_loop
    probes =
      DIRECTION_OFFSETS.keys
        .map {|direction|
          step_from(start, direction)
        }
        .compact!
        .map {|first_step, direction| [ [start, first_step], direction ] }

    while probes do
      path, direction = probes.pop
      next_coords, direction = step_from(path.last, direction)

      case direction
      when :north, :south, :west, :east
        probes << [(path + [next_coords]), direction]
      when :stop
        return path
      end
    end
  end

  def step_from(coords, direction)
    maybe_next_coords = towards(coords, direction)
    return nil unless @grid.cover?(maybe_next_coords)

    maybe_next_direction = PIPE_FLOWS.fetch([direction, at(maybe_next_coords)], nil)
    return nil unless maybe_next_direction
    [
      maybe_next_coords,
      maybe_next_direction
    ]
  end

  def inner_cells
    @inner_cells ||= find_inner_cells
  end

  # Very much copied from Bill Mill's hack; works for junk and real input, but off-by-one for others.
  def find_inner_cells
    innercells = []
    @grid.row_bounds.map do |row|
      bars = 0
      @grid.column_bounds.map do |column|
        on_the_loop = loop_path.include?([row,column])
        if on_the_loop && ["│", "└", "┘", "╳"].include?(at([row, column]))
            bars += 1
        elsif bars % 2 == 1 && !on_the_loop
            innercells << [row,column]
        end
      end
    end
    return innercells
  end

  def at(coords)
      @grid.at(coords)
  end

  def towards(from_coords, direction)
    raise("what kind of direction is #{direction.inspect}?") if !DIRECTION_OFFSETS.keys.include?(direction)
    from_coords
      .zip(DIRECTION_OFFSETS[direction])
      .map { |p| p.reduce(&:+) }
  end

  DIRECTION_OFFSETS = {
    north: [-1, 0],
    south: [ 1, 0],
    west:  [ 0,-1],
    east:  [ 0, 1],
    stop:  [ 0, 0],
  }

  # [step travel direction, pipe type] => next step travel direction
  PIPE_FLOWS = {
    # | is a vertical pipe connecting north and south.
    [:north, "│"] => :north,
    [:south, "│"] => :south,
    # - is a horizontal pipe connecting east and west.
    [:east, "─"] => :east,
    [:west, "─"] => :west,
    # L is a 90-degree bend connecting north and east.
    [:south, "└"] => :east,
    [:west, "└"] => :north,
    # J is a 90-degree bend connecting north and west.
    [:south, "┘"] => :west,
    [:east, "┘"] => :north,
    # 7 is a 90-degree bend connecting south and west.
    [:east, "┐"] => :south,
    [:north, "┐"] => :west,
    # F is a 90-degree bend connecting south and east.
    [:west, "┌"] => :south,
    [:north, "┌"] => :east,
    # . is ground; there is no pipe in this tile.
    "░" => :cannot_enter_ground,
    # S is the starting position of the animal;
    # there is a pipe on this tile, but your sketch doesn't
    # show what shape the pipe has.
    # Let start be entered from any direction and then
    # there are no further steps.
    [:north, "╳"] => :stop,
    [:south, "╳"] => :stop,
    [:east, "╳"] => :stop,
    [:west, "╳"] => :stop,
  }

  def to_ugly_sweater
    "\n" +
    @grid.to_s { |coords, value|
      if loop_path.include?(coords)
        value.make_it_red
      elsif inner_cells.include?(coords)
        "I".make_it_green.make_it_bold
      else
        value.make_it_green
      end
    }
  end
end
