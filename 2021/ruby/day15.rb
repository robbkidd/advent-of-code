class Day15
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :cave, :row_bounds, :column_bounds

  # @example
  #   day.cave.fetch([0,0]) #=> 1
  def initialize(input=nil)
    @cave = {}
    (input || real_input)
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index { |row, r|
        row.each_with_index{ |risk_level, c|
          @cave[[r,c]] = risk_level
        }
      }

    @row_bounds,
    @column_bounds = @cave
      .keys
      .transpose
      .map{ |dimension| Range.new(*dimension.minmax) }
  end

  # @example
  #   day.part1 #=> 40
  def part1
    start = [0,0]
    goal = [@row_bounds.max, @column_bounds.max]
    steps = edsger_do_your_thing(cave, start, goal)
    shortest_path = path(steps, goal)
    puts
    puts highlight_path(shortest_path)

    shortest_path[0..-2]
      .map{ |position| cave[position] }
      .reduce(&:+)
  end

  def part2
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

  def edsger_do_your_thing(grid, start, goal)
    backsteps = { start => nil }
    costs = { start => 0 }
    costs.default = Float::INFINITY

    survey_queue = [[0,start]]
    while (_cost, check_pos = survey_queue.pop) do
      break if check_pos == goal

      adjacent_positions(check_pos).each do |neighbor|
        neighbor_cost = costs[check_pos] + cave[neighbor]
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
    backsteps
  end

  def highlight_path(path)
    row_bounds.map { |r|
      column_bounds.map { |c|
        if path.include?([r,c])
          "\e[7m#{cave[[r,c]]}\e[0m"
        else
          cave[[r,c]].to_s
        end
      }.join
    }.join("\n")
    .concat("\n")
  end

  NEIGHBOR_OFFSETS = [[-1, 0],[1, 0],[0, -1],[0, 1]]
  # @example
  #   day.adjacent_positions([0,0]) #=> [[1, 0], [0, 1]]
  #   day.adjacent_positions([5,42]) #=> []
  def adjacent_positions(position)
    NEIGHBOR_OFFSETS
      .map { |offset|
        position
          .zip(offset)
          .map {|p| p.reduce(&:+)}
      }
      .filter { |row, column|
        @row_bounds.cover?(row) && @column_bounds.cover?(column)
      }
  end

  def real_input
    File.read('../inputs/day15-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
  INPUT
end

