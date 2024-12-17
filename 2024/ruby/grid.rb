require 'fc' # FastContainers::PriorityQueue

class Grid
  include Enumerable

  attr_reader :row_bounds, :column_bounds

  def initialize(input)
    @input = input
    case input
    when String
      @the_grid = Hash.new { |(r, c)| raise "No data parsed." }
    when Hash
      @the_grid = input
      @the_grid.default_proc = DEFAULT_VALUE_PROC
      compute_bounds
    else
      raise "New grids can only be from Strings to parse or a prefilled Hash."
    end
  end

  DEFAULT_VALUE_PROC = proc { |_hash, key| :out_of_bounds }

  DEFAULT_VALUE_TRANFORM_PROC = proc { |v| v }

  def set_value_transform_proc(&block)
    raise "#{__method__} must be called with a block." unless block_given?
    @value_transform_proc = block

    self
  end

  def values_are_integers
    set_value_transform_proc { |v| v.to_i }

    self
  end

  ### Parsing

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

    @the_grid.default_proc = DEFAULT_VALUE_PROC

    compute_bounds

    self
  end

  def compute_bounds
    @row_bounds, @column_bounds =
      @the_grid.keys.transpose.map { |dimension| Range.new(*dimension.minmax) }

    self
  end

  def set_grid(a_grid)
    raise "A grid's gotta be a Hash" unless a_grid.is_a? Hash
    raise "Grid keys gotta be 2-element Arrays" unless a_grid.keys.all? { |key|
      key.is_a?(Array) && key.size == 2
    }

    @the_grid = a_grid
    @the_grid.default_proc = DEFAULT_VALUE_PROC
    compute_bounds
    self
  end

  ### Getting and Setting

  def set(coords, value)
    @the_grid[coords] = value
  end

  def at(coords)
    (@value_transform_proc || DEFAULT_VALUE_TRANFORM_PROC).call(
      @the_grid[coords.to_a]
    )
  end

  def cover?(coords)
    raise "No data loaded." unless (@row_bounds && @column_bounds)
    at(coords) != :out_of_bounds
  end

  ### Enumerating

  def each
    @the_grid.each { |coords, value| yield coords, value }
  end

  ### Neigbors & Pathing

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

  def neighbors_for(coords)
    OFFSET_TO_DIRECTION
      .keys
      .map { |offset|
        [ offset, coords.zip(offset).map { |p| p.reduce(&:+) } ]
      }
      .select { |_direction, neighbor_coords| self.cover? neighbor_coords }
      .to_h
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

      neighbors_for(check_pos).each do |_direction, neighbor|
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


  ### Display

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
