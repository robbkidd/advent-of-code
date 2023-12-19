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
  #   day.part2 #=> '?'
  def part2
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
end

class HeatLossMap
  require_relative 'grid'
  require 'matrix'
  require 'fc'

  attr_reader :grid

  def initialize(input)
    @input = input
    @grid = Grid.new(input)
    @grid.parse do |coords, heat_loss|
      @grid.set(coords, heat_loss.to_i)
    end
  end

  def start
    @start ||= [0,0]
  end

  def goal
    @goal ||= [ @grid.row_bounds.max, @grid.column_bounds.max ]
  end

  def total_heat_loss_on_coolest_path
    shortest_path_to_goal[..-2] # don't include the map start
      .map {|coords, _dir, _moves| @grid.at(coords) }
      .reduce(&:+)
  end

  UPWARDS    = [-1, 0]
  DOWNWARDS  = [ 1, 0]
  LEFTWARDS  = [ 0,-1]
  RIGHTWARDS = [ 0, 1]

  DIRECTIONS = [UPWARDS, DOWNWARDS, LEFTWARDS, RIGHTWARDS]

  # @example
  #   new("112999\n911111\n").shortest_path_to_goal.map(&:first) #=> [[1, 5], [1, 4], [1, 3], [1, 2], [0, 2], [0, 1], [0, 0]]
  def shortest_path_to_goal
    backsteps = Hash.new
    backsteps[[start, [0,0], 0]] = nil # there's no previous step from the start of a path

    costs = Hash.new(Float::INFINITY) # until computed, the cost to step to a neighbor is infinitely expensive
    costs[[start, [0,0], 0]] = 0 # we start here with no current direction, though, so it's cheap

    survey_queue = FastContainers::PriorityQueue.new(:min)
    survey_queue.push([start, [0,0], 0], 0)
    while !survey_queue.empty?
      check_pos, current_direction, moves_so_far_in_that_direction = survey_queue.pop
      break if check_pos == goal

      next_blocks(check_pos, current_direction, moves_so_far_in_that_direction)
        .each do |neighbor, new_direction, moves|
          neighbor_cost =
            if !@grid.cover?(neighbor) # don't go off the map
              Float::INFINITY
            elsif new_direction == reverse_direction(current_direction) # no backing up
              Float::INFINITY
            elsif current_direction == new_direction && moves > 3 # no more than 3 blocks in a direction
              Float::INFINITY
            else
              @grid.at(neighbor) + costs[[check_pos, current_direction, moves_so_far_in_that_direction]]
            end

          if neighbor_cost < costs[[neighbor, new_direction, moves]]
            costs[[neighbor, new_direction, moves]] = neighbor_cost
            backsteps[[neighbor, new_direction, moves]] = [check_pos, current_direction, moves_so_far_in_that_direction]

            survey_queue.push([neighbor, new_direction, moves], neighbor_cost)
          end
        end
    end

    path = [ costs.keys.select{|coords, _, _| coords == goal }.first ]
    step_backwards = backsteps[path.first]
    while step_backwards
      path.push(step_backwards)
      step_backwards = backsteps[step_backwards]
    end
    path
  end

  # @example starting_out
  #   m = new(Day17::EXAMPLE_INPUT)
  #   m.next_blocks([0,0], [0,0], 0) #=> [ [[1,0], DOWNWARDS, 1], [[0,1], RIGHTWARDS, 1] ]
  # @example gotta_turn
  #   m = new(Day17::EXAMPLE_INPUT)
  #   m.next_blocks([0,8], RIGHTWARDS, 3) #=> [ [[1,8], DOWNWARDS, 1], [[0, 7], LEFTWARDS, 1], [[0, 9], RIGHTWARDS, 4] ]
  def next_blocks(from_coords, current_direction, moves_so_far_in_that_direction)
    DIRECTIONS
      .map { |new_vector| [move_to(from_coords, new_vector), new_vector] }
      .reject { |neighbor, new_vector| !@grid.cover?(neighbor) }
      .map { |neighbor, new_vector|
        [
          neighbor,
          new_vector,
          current_direction == new_vector ? moves_so_far_in_that_direction += 1 : 1
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
    (Vector.elements(direction, copy: false) * -1).to_a
  end
end
