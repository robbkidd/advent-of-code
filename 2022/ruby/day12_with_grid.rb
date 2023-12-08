require_relative "day"
require_relative "grid"

class Day12 < Day
  def initialize(*)
    super
    @path_finder = HillClimbingAlgorithm.new(input)
  end

  # @example
  #   day.part1 #=> 31
  def part1
    @path_finder
      .shortest_hike_from_start
      .tap { |path| @path_finder.print(path) }
      .length - 1 # start doesn't count towards steps
  end

  # @example
  #   day.part2 #=> 29
  def part2
    @path_finder
      .shortest_hike_from_lowest_points
      .tap { |path| @path_finder.print(path) }
      .length - 1 # start doesn't count towards steps
  end

  EXAMPLE_INPUT = <<~INPUT
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
  INPUT
end

class HillClimbingAlgorithm
  def initialize(input = "")
    @start_coords = nil
    @goal_coords = nil

    @hills = Grid.new(input)
    @hills.parse do |coords, elevation|
      @start_coords = coords if elevation == "S"
      @goal_coords = coords if elevation == "E"
    end
    @hills.set_step_cost_calculator do |h, from, to|
      if hikable?(h.at(from), h.at(to))
        HIKABLE_HILL_COST
      else
        CLIMBING_GEAR_REQUIRED_COST
      end
    end
  end

  HIKABLE_HILL_COST = 1 # one step on the hike
  CLIMBING_GEAR_REQUIRED_COST = Float::INFINITY # effectively ruling them out

  # @example from puzzle
  #   new.hikable? 'm', 'n' #=> true
  #   new.hikable? 'm', 'a' #=> true
  #   new.hikable? 'n', 'm' #=> true
  #   new.hikable? 'm', 'o' #=> false
  # @example treat start like a
  #   new.hikable? 'S', 'a' #=> true
  #   new.hikable? 'a', 'S' #=> true
  #   new.hikable? 'S', 'c' #=> false
  #   new.hikable? 'a', 'c' #=> false
  # @example treat goal like z
  #   new.hikable? 'y', 'z' #=> true
  #   new.hikable? 'y', 'E' #=> true
  #   new.hikable? 'x', 'E' #=> false
  def hikable?(from_elevation, to_elevation)
    [to_elevation, from_elevation].map do |el| # "S", "E", or [a-z],
        el
          .tr("S", "a") # treat S as lowest (a)
          .tr("E", "z") # treat E as highest (z)
          .ord # integer value for elevation character for comparison
      end
      .reduce(&:-) <= 1 # elevation diff is less than 1 higher
  end

  def shortest_hike_from_start
    @hills.shortest_path_between(@start_coords, @goal_coords)
  end

  def shortest_hike_from_lowest_points
    @hills
      .select { |coords, elevation| %w[S a].include?(elevation) }
      .map { |coords, _| @hills.shortest_path_between(coords, @goal_coords) }
      .reject(
        &:empty?
      ) # reject if there was no hikable path from some lowest points
      .min_by { |path| path.length }
  end

  def print(path)
    puts "\n" + @hills.render_path(path)
  end
end
