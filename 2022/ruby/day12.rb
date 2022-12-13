require_relative 'day'

class Day12 < Day # >

  def initialize(*)
    super
    @start_coords = nil
    @goal_coords  = nil

    @hills = Grid.new(input)

    @hills.parse do |coords, elevation|
      @start_coords = coords if elevation == "S"
      @goal_coords  = coords if elevation == "E"
    end

    @neighbor_not_too_high = proc { |coords, neighbor_coords|
      [ @hills.at(neighbor_coords) , @hills.at(coords) ]
        .map{ |e| e.tr("S","a").tr("E","z").ord }
        .reduce(&:-) <= 1
    }

    @path_cost_increase_to_neighbor = proc { |_here, _there| 1 }
  end

  # @example
  #   day.part1 #=> 31
  def part1
    shortest_path_to_goal =
      @hills.edsger_do_your_thing_between(
        @start_coords, @goal_coords,
        @neighbor_not_too_high,
        @path_cost_increase_to_neighbor
      )

    shortest_path_to_goal.count - 1 # don't include the start in step count
  end

  # @example
  #   day.part2 #=> 29
  def part2
    lowest_coords =
      @hills
        .select { |coords, elevation| ["S", "a"].include?(elevation) }
        .map { |coords,_| coords }

    lowest_coords
      .map { |coords|
        @hills.edsger_do_your_thing_between(
          coords, @goal_coords,
          @neighbor_not_too_high,
          @path_cost_increase_to_neighbor
        )
      }
      .min_by(&:length)
      .length - 1 # don't include the start in step count
  end

  EXAMPLE_INPUT = <<~INPUT
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
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
  #   grid = new(Day12::EXAMPLE_INPUT)
  #   grid.at([0,0])       #=> raise "No data loaded."
  #   grid.parse
  #   grid.at([0,0])       #=> "S"
  #   grid.at([-100,-100]) #=> raise KeyError, "Coordinates not found on grid: [-100, -100]"
  def at(coords)
    @the_grid[coords]
  end

  OFFSET_TO_DIRECTION = {
    # r   c
    [-1,  0] => '^', # up a row
    [ 1,  0] => 'v', # down a row
    [ 0, -1] => '<', # left a column
    [ 0,  1] => '>', # right a column
  }

  def adjacent_to(coords)
      OFFSET_TO_DIRECTION.keys
        .map { |offset|
          coords
            .zip(offset)
            .map {|p| p.reduce(&:+)}
        }
        .select { |r,c| @the_grid.has_key?([r,c]) }
  end

  def edsger_do_your_thing_between(start, goal, filter_proc, compute_cost_proc)
    backsteps = { start => nil }
    costs = { start => 0 }
    costs.default = Float::INFINITY

    survey_queue = [[0,start]]
    while (_cost, check_pos = survey_queue.pop) do
      break if check_pos == goal

      adjacent_to(check_pos)
        .filter{ |neighbor_coords| filter_proc.call(check_pos, neighbor_coords) }
        .each do |neighbor|
          neighbor_cost = costs[check_pos] + compute_cost_proc.call(check_pos, neighbor)

          if neighbor_cost < costs[neighbor]
            costs[neighbor] = neighbor_cost
            backsteps[neighbor] = check_pos

            survey_queue.push([neighbor_cost, neighbor])
            survey_queue
              .sort_by! { |cost, _pos| cost }
              .reverse!
          end
        end
    end
    path(backsteps, goal)
  end

  def path(backsteps, goal)
    path = [goal]
    step_backwards = backsteps[goal]
    while step_backwards do
      path.push(step_backwards)
      step_backwards = backsteps[step_backwards]
    end
    path
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

  # @example
  #   grid = new(Day12::EXAMPLE_INPUT).parse
  #   grid.to_s  #=> Day12::EXAMPLE_INPUT
  def to_s
    transform_proc = @to_s_proc || DEFAULT_TO_S_PROC
    @row_bounds.map { |row|
      @column_bounds.map { |column|
        transform_proc.call( at([row, column]) )
      }.join("")
    }.join("\n") + "\n"
  end
end
