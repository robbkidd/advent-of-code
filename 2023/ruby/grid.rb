class Grid
  require "fc"
  include Enumerable

  attr_reader :row_bounds, :column_bounds

  def initialize(input)
    @input = input
    @the_grid = Hash.new { |(r, c)| raise "No data parsed." }
  end

  def each
    @the_grid.each { |coords, value| yield coords, value }
  end

  # @example
  #   grid = new("")
  #   grid.at([0,0])       #=> raise("No data loaded.")
  #   grid.set([0,0], ".")
  #   grid.at([0,0])      #=> "."
  def set(coords, value)
    @the_grid[coords] = value
  end

  # @example
  #   grid = new("S..\n.\n..")
  #   grid.at([0,0])       #=> raise "No data parsed."
  #   grid.parse
  #   grid.at([0,0])       #=> "S"
  #   grid.at([-100,-100]) #=> raise KeyError, "Coordinates not found on grid: [-100, -100]"
  def at(coords)
    (@value_transform_proc || DEFAULT_VALUE_TRANFORM_PROC).call(
      @the_grid[coords]
    )
  end

  DEFAULT_VALUE_TRANFORM_PROC = proc { |v| v }

  def values_are_integers
    set_value_transform_proc { |v| v.to_i }
  end

  def set_value_transform_proc(&block)
    raise "#{__method__} must be called with a block." unless block_given?
    @value_transform_proc = block

    self
  end

  def cover?(coords)
    raise "No data loaded." unless (@row_bounds && @column_bounds)
    @row_bounds.cover?(coords[0]) && @column_bounds.cover?(coords[1])
  end

  def manhattan_distance(here, there)
    [here, there].transpose.map { |a, b| (a - b).abs }.reduce(&:+)
  end

  OFFSET_TO_DIRECTION = {
    # r   c
    [-1, 0] => "^", # up a row
    [1, 0] => "v", # down a row
    [0, -1] => "<", # left a column
    [0, 1] => ">" # right a column
  }

  # @example exception when grid hasn't been populated
  #   grid = new(Day12::EXAMPLE_INPUT)
  #   grid.neighbors_for([2,5]) #=> raise "No data loaded."
  #
  # @example in bounds
  #   grid = new(Day12::EXAMPLE_INPUT).parse
  #   grid.neighbors_for([2,5]) #=> [ [1,5], [3,5], [2,4], [2,6] ]
  #
  # @example on the edge
  #   grid = new(Day12::EXAMPLE_INPUT).parse
  #   grid.neighbors_for([0,0]) #=> [ [1,0], [0,1] ]
  def neighbors_for(coords)
    OFFSET_TO_DIRECTION
      .keys
      .map { |offset| coords.zip(offset).map { |p| p.reduce(&:+) } }
      .select { |neighbor_coords| self.cover? neighbor_coords }
  end

  # default cost to step to a neighbor
  # if some neighbors ought to be excluded outright, return Float::INFINITY as their cost
  DEFAULT_STEP_COST_CALCULATOR_PROC =
    proc { |_grid, _from_coords, _to_coords| 1 }

  # just in case you want to keep multiple procs around and swap them in and out
  attr_writer :step_cost_calculator_proc

  # or use this to chain setting it during grid initialization
  def set_step_cost_calculator(&block)
    raise "#{__method__} must be called with a block." unless block_given?
    @step_cost_calculator_proc = block

    self
  end

  def shortest_path_between(start, goal, &block)
    cost_calculator =
      if block_given?
        block
      elsif @step_cost_calculator_proc
        @step_cost_calculator_proc
      else
        DEFAULT_STEP_COST_CALCULATOR_PROC
      end

    backsteps = Hash.new
    backsteps[start] = nil # there's no previous step from the start of a path

    costs = Hash.new(Float::INFINITY) # until computed, the cost to step to a neighbor is infinitely expensive
    costs[start] = 0 # we start here, though, so it's cheap

    survey_queue = FastContainers::PriorityQueue.new(:min)
    survey_queue.push(start, 0)
    while !survey_queue.empty?
      check_pos = survey_queue.pop
      break if check_pos == goal

      neighbors_for(check_pos).each do |neighbor|
        neighbor_cost =
          costs[check_pos] + cost_calculator.call(self, check_pos, neighbor)

        if neighbor_cost < costs[neighbor]
          costs[neighbor] = neighbor_cost
          backsteps[neighbor] = check_pos

          survey_queue.push(neighbor, neighbor_cost)
        end
      end
    end

    return [] unless backsteps.include?(goal)

    path = [goal]
    step_backwards = backsteps[goal]
    while step_backwards
      path.push(step_backwards)
      step_backwards = backsteps[step_backwards]
    end
    path
  end

  def render_path(path)
    step_directions = path_to_direction_map(path)

    self.to_s do |coords, value|
      if coords == path.first
        at(coords)
      elsif dir = step_directions[coords]
        "\e[41m\e[1m#{dir}\e[0m"
      else
        "\e[32m.\e[0m"
      end
    end
  end

  def path_to_direction_map(path)
    direction_of_travel_from = Hash.new
    path.each_cons(2) do |to, from|
      offset = [to[0] - from[0], to[1] - from[1]]
      direction_of_travel_from[from] = OFFSET_TO_DIRECTION.fetch(offset)
    end
    direction_of_travel_from
  end

  # @example
  #
  def parse
    split_input =
      case @input
      when Array # assume the lines and chars have been split already
        @input
      when String
        @input
          .split("\n")
          .map { |line| line.chars }
      else
        raise("don't know how to parse #{input.inspect}")
      end

    split_input
      .each_with_index do |row, r|
        row.each_with_index do |char, c|
          @the_grid[[r, c]] = char
          yield [r, c], char if block_given?
        end
      end

    @the_grid.default_proc =
      proc do |_hash, key|
        raise KeyError, "Coordinates not found on grid: #{key}"
      end

    @row_bounds, @column_bounds =
      @the_grid.keys.transpose.map { |dimension| Range.new(*dimension.minmax) }

    self
  end

  # @example by default, stringifies input value for a grid location
  #   grid = new("abcd\nefgh\n").parse
  #   grid.to_s  #=> "abcd\nefgh\n"
  #
  # @example transforms with an assigned to_s_proc
  #   grid = new("abcd\nefgh\n").parse
  #   grid.to_s  #=> "abcd\nefgh\n"
  #   grid.to_s_proc = proc {|_coords, value| (value.ord + 1).chr }
  #   grid.to_s  #=> "bcde\nfghi\n"
  #   grid.to_s_proc = nil
  #   grid.to_s  #=> "abcd\nefgh\n"
  #
  # @example transforms with a given block
  #   grid = new("abcd\nefgh\n").parse
  #   grid.to_s  #=> "abcd\nefgh\n"
  #   grid.to_s { |_coords, value| (value.ord + 1).chr } #=> "bcde\nfghi\n"
  #   grid.to_s  #=> "abcd\nefgh\n"
  #
  # @example block given takes priority over assigned to_s_proc
  #   grid = new("abcd\nefgh\n").parse
  #   grid.to_s  #=> "abcd\nefgh\n"
  #   grid.to_s_proc = proc {|_, _| raise "to_s_proc called" }
  #   grid.to_s  #=> raise "to_s_proc called"
  #   grid.to_s { |_coords, value| (value.ord + 1).chr } #=> "bcde\nfghi\n"
  #
  attr_writer :to_s_proc
  DEFAULT_TO_S_PROC = proc { |_coords, value| value.to_s }
  def to_s(&block)
    transformer =
      if block_given?
        block
      elsif @to_s_proc
        @to_s_proc
      else
        DEFAULT_TO_S_PROC
      end

    @row_bounds
      .map do |row|
        @column_bounds
          .map { |column| transformer.call([row, column], at([row, column])) }
          .join("")
      end
      .join("\n") + "\n"
  end
end
