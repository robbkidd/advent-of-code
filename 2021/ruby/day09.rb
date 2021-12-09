class Day09
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input, :depths

  def initialize(input=nil)
    @input = input || real_input
    @depths = Hash.new(:out_of_bounds)
  end

  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.part1 #=> 15
  def part1
    parse_input

    depths
      .select{ |location, measured_depth|
        adjacent_locations(location)
          .map{ |neighbor_loc|
            depths[neighbor_loc]
          }
          .reject{ |neighbor_depth|
            neighbor_depth == :out_of_bounds || neighbor_depth > measured_depth
          }
          .empty?
      }
      .values
      .map{ |low_point| low_point + 1 }
      .reduce(&:+)
  end

  ADJACENCY_DIRECTIONS = {
    up: [-1,0],
    down: [1, 0],
    left: [0, -1],
    right: [0, 1],
  }

  ADJACENCY_OFFSETS = ADJACENCY_DIRECTIONS.values

  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.adjacent_locations([0,0]) #=> Day09::ADJACENCY_OFFSETS
  #   d.adjacent_locations([5,42]) #=> [[4, 42], [6, 42], [5, 41], [5, 43]]
  def adjacent_locations(location)
    ADJACENCY_OFFSETS.map{ |offset|
      location
        .zip(offset)
        .map {|p| p.reduce(&:+)}
    }
  end

  def part2
  end

  # Updates @depths with values from input
  def parse_input
    input
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index{ |row, r|
        row.each_with_index{ |measured_depth, c|
          depths[[r,c]] = measured_depth
        }
      }
  end

  def real_input
    File.read('../inputs/day09-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
  INPUT
end
