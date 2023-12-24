require_relative 'day'

class Day21 < Day # >

  def part1
    sc = StepCounter.new(input)
    64.times { sc.step }
    sc.garden_plots_reached
  end

  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
  INPUT
end

class StepCounter
  require_relative 'grid'
  require 'set'

  attr_reader :grid, :start

  # @example
  #   sc = StepCounter.new(Day21::EXAMPLE_INPUT)
  #   sc.start #=> [5,5]
  def initialize(input)
    @input = input
    @grid = Grid.new(input)
    @start = nil
    @grid.parse do |coords, value|
      @start = coords if value == "S"
    end
    @possible_ends = {@start => "O"}
  end

  # @example
  #   sc = StepCounter.new(Day21::EXAMPLE_INPUT)
  #   sc.step.keys #=> [[4, 5], [5, 4]]
  #   sc.step.keys #=> [[3, 5], [5, 5], [6, 4], [5, 3]]
  #   sc.step.count #=> 6
  def step
    new_ends = {}
    @possible_ends
      .each do |coords, _|
        @grid
          .neighbors_for(coords)
          .select{ |neighbor| @grid.at(neighbor) != "#" }
          .each do |neighbor|
            new_ends[neighbor] = "O"
          end
      end
    @possible_ends = new_ends
  end

  # @example
  #   sc = StepCounter.new(Day21::EXAMPLE_INPUT)
  #   6.times { sc.step }
  #   sc.garden_plots_reached #=> 16
  def garden_plots_reached
    @possible_ends.count
  end
end
