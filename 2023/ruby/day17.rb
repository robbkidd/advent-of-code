require_relative 'day'

class Day17 < Day # >

  # @example
  #   day.part1 #=> 102
  def part1
    HeatLossMap
      .new(input)
      .total_heat_loss_on_coolest_path
  end

  # example
  #   day.part2 #=> 94
  # @example unfortunate_path
  #   hlm = HeatLossMap.new(EXAMPLE_PART2_ALT_INPUT, :ultra)
  #   hlm.total_heat_loss_on_coolest_path #=> 71
  def part2
    HeatLossMap
      .new(input, :ultra)
      .total_heat_loss_on_coolest_path
  end

  EXAMPLE_INPUT = <<~INPUT
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
  INPUT

  EXAMPLE_PART2_ALT_INPUT = <<~INPUT
    111111111111
    999999999991
    999999999991
    999999999991
    999999999991
  INPUT
end

class HeatLossMap
  require_relative 'grid'
  require 'matrix'
  require 'fc'
  require_relative 'ugly_sweater'
  include UglySweater


  attr_reader :grid
  attr_accessor :crucible_type

  def initialize(input, crucible_type=:standard)
    @input = input
    @grid = Grid.new(input)
    @grid.parse do |coords, heat_loss|
      @grid.set(coords, heat_loss.to_i)
    end
    @crucible_type = crucible_type
  end

  def start
    @start ||= [0,0]
  end

  def goal
    @goal ||= [ @grid.row_bounds.max, @grid.column_bounds.max ]
  end

  def total_heat_loss_on_coolest_path
    shortest_path_to_goal[..-2] # don't include the map start
      .map {|coords, _dir, _consec_blocks| @grid.at(coords) }
      .reduce(&:+)
  end

  UPWARDS    = [-1, 0]
  DOWNWARDS  = [ 1, 0]
  LEFTWARDS  = [ 0,-1]
  RIGHTWARDS = [ 0, 1]

  DIRECTIONS = [UPWARDS, DOWNWARDS, LEFTWARDS, RIGHTWARDS]

  # @example
  #   new("112999\n911111\n").shortest_path_to_goal.map(&:first) #=> [[1, 5], [1, 4], [1, 3], [1, 2], [0, 2], [0, 1], [0, 0]]
  # @example unfortunate_path
  #   ultra = new(Day17::EXAMPLE_PART2_ALT_INPUT, :ultra)
  #   ultra.shortest_path_to_goal
  #   puts ultra
  #   ultra.shortest_path_to_goal #=> []
  def shortest_path_to_goal
    @shortest_path_to_goal ||= (
      backsteps, costs = find_path

      path = [ costs.keys.select{|coords, _, _| coords == goal }.first ]
      step_backwards = backsteps[path.first]
      while step_backwards
        path.push(step_backwards)
        step_backwards = backsteps[step_backwards]
      end
      path
    )
  end

  def find_path
    backsteps = Hash.new
    backsteps[[start, [0,0], 0]] = nil # there's no previous step from the start of a path

    costs = Hash.new(Float::INFINITY) # until computed, the cost to step to a neighbor is infinitely expensive
    costs[[start, [0,0], 0]] = 0 # we start here with no current direction, though, so it's cheap

    survey_queue = FastContainers::PriorityQueue.new(:min)
    survey_queue.push([start, [0,0], 0], 0)
    while !survey_queue.empty?
      check_pos, current_direction, consecutive_blocks_so_far = survey_queue.pop
      break if check_pos == goal

      next_blocks(check_pos, current_direction, consecutive_blocks_so_far)
        .each do |neighbor, next_direction, consecutive_blocks|
          neighbor_cost =
            costs[[check_pos, current_direction, consecutive_blocks_so_far]] +
            send("#{crucible_type}_crucible_cost".to_sym, current_direction, neighbor, next_direction, consecutive_blocks)

          if neighbor_cost < costs[[neighbor, next_direction, consecutive_blocks]]
            costs[[neighbor, next_direction, consecutive_blocks]] = neighbor_cost
            backsteps[[neighbor, next_direction, consecutive_blocks]] = [check_pos, current_direction, consecutive_blocks_so_far]

            survey_queue.push([neighbor, next_direction, consecutive_blocks], neighbor_cost)
          end
        end
    end

    [backsteps, costs]
  end

  def standard_crucible_cost(current_direction, neighbor, next_direction, consecutive_blocks)
    if !@grid.cover?(neighbor) # don't go off the map
      Float::INFINITY
    elsif next_direction == reverse_direction(current_direction) # no backing up
      Float::INFINITY
    elsif current_direction == next_direction && consecutive_blocks > 3 # no more than 3 blocks in a direction
      Float::INFINITY
    else
      @grid.at(neighbor)
    end
  end

  def ultra_crucible_cost(current_direction, neighbor, next_direction, consecutive_blocks)
    # don't go off the map
    if !@grid.cover?(neighbor)
      Float::INFINITY

    # no backing up
    elsif next_direction == reverse_direction(current_direction)
      Float::INFINITY

    # no more than 10 blocks in a direction
    elsif current_direction == next_direction && consecutive_blocks > 10
      Float::INFINITY

    # must go 4 blocks before stopping
    elsif neighbor == goal && consecutive_blocks < 4
      Float::INFINITY

    # must go 4 blocks before turning
    elsif current_direction != next_direction && consecutive_blocks < 4
      Float::INFINITY

    else
      @grid.at(neighbor)
    end
  end

  # @example starting_out
  #   m = new(Day17::EXAMPLE_INPUT)
  #   m.next_blocks([0,0], [0,0], 0) #=> [ [[1,0], DOWNWARDS, 1], [[0,1], RIGHTWARDS, 1] ]
  # @example gotta_turn
  #   m = new(Day17::EXAMPLE_INPUT)
  #   m.next_blocks([0,8], RIGHTWARDS, 3) #=> [ [[1,8], DOWNWARDS, 1], [[0, 7], LEFTWARDS, 1], [[0, 9], RIGHTWARDS, 4] ]
  def next_blocks(from_coords, current_direction, consecutive_blocks)
    DIRECTIONS
      .map { |new_vector| [move_to(from_coords, new_vector), new_vector] }
      .reject { |neighbor, new_vector| !@grid.cover?(neighbor) }
      .map { |neighbor, new_vector|
        [
          neighbor,
          new_vector,
          current_direction == new_vector ? consecutive_blocks += 1 : 1
        ]
      }
  end

  def move_to(from, direction)
    ( Vector.elements(from, copy: false) +
      Vector.elements(direction, copy: false)).to_a
  end

  # @example
  #   new('').reverse_direction(RIGHTWARDS) #=> LEFTWARDS
  def reverse_direction(direction)
    direction.map {_1 * -1}
  end

  def to_s
    if @shortest_path_to_goal
      steps =
        @shortest_path_to_goal
          .map {|coords, dir, _consec_blocks| [coords, dir] }
          .to_h

      @grid.to_s do |coords, value|
        if dir = Grid::OFFSET_TO_DIRECTION[steps[coords]]
          dir.to_s.make_it_red
        else
          value.to_s.make_it_green
        end
      end.prepend("\n")
    else
      @grid.to_s
    end
  end
end
