require_relative 'day'
require_relative 'grid'

class Day14 < Day # >

  def initialize(input=nil, dimensions: [101, 103])
    super(input)
    @robots =
      @input
        .split("\n")
        .map {|line| Robot.new(line) }
    @dimensions = dimensions
  end

  # @example
  #   day = new(EXAMPLE_INPUT, dimensions: [11,7])
  #   day.part1 #=> 12
  def part1
    mid_width = @dimensions[0] / 2
    mid_height = @dimensions[1] / 2

    @robots
      .map { |robot| robot.position_at_time(100, dimensions: @dimensions) }
      .tally
      .inject(Hash.new(0)) { |quad_counts, (position, robot_count)|
        case
        when position[0] == mid_width || position[1] == mid_height ; # skip mids
        else
          if position[0] < mid_width
            if position[1] < mid_height
              quad_counts[:top_left] += robot_count
            else
              quad_counts[:bottom_left] += robot_count
            end
          else
            if position[1] < mid_height
              quad_counts[:top_right] += robot_count
            else
              quad_counts[:bottom_right] += robot_count
            end
          end
        end

        quad_counts
      }
      .values
      .reduce(&:*)
  end

  def part2
    seconds = 0
    until @robots
            .map { |robot| robot.position_at_time(seconds, dimensions: @dimensions) }
            .tally
            .all? { |_position, count| count == 1 } do
      seconds += 1
    end

    easter_egg =
      @robots
        .map { |robot| robot.position_at_time(seconds, dimensions: @dimensions) }
        .tally

    puts ugly_christmas_sweater(
      Grid
        .new('')
        .set_grid(easter_egg)
        .to_s { |coords, value| easter_egg.key?(coords) ? '#' : '.' }
    )

    seconds
  end

  class Robot
    # @example
    #   robot = new('p=2,4 v=2,-3')
    #   robot.start_position #=> [ 2, 4]
    #   robot.velocity       #=> [ 2,-3]
    def initialize(input_line)
      @start_column, @start_row, @delta_column, @delta_row = input_line.scan(/-?\d+/).map(&:to_i)
    end

    def start_position = [@start_column, @start_row]
    def velocity       = [@delta_column, @delta_row]

    # @example
    #   robot = new('p=2,4 v=2,-3')
    #   robot.position_at_time    #=> [ 2, 4]
    #   robot.position_at_time(1) #=> [ 4, 1]
    #   robot.position_at_time(2) #=> [ 6, 5]
    #   robot.position_at_time(3) #=> [ 8, 2]
    #   robot.position_at_time(4) #=> [10, 6]
    def position_at_time(seconds=0, dimensions: [11, 7])
      new_row = (@start_row + (@delta_row * seconds)) % dimensions[1]
      new_row += dimensions[1] if new_row.negative?
      new_column = (@start_column + (@delta_column * seconds)) % dimensions[0]
      new_column += dimensions[0] if new_column.negative?

      [ new_column, new_row ]
    end
  end

  EXAMPLE_INPUT = File.read("../inputs/day14-example-input.txt")
end
