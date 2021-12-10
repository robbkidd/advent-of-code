require 'set'
class Day09
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
    day.display_heightmap(:basins)
  end

  attr_reader :input, :depths, :row_bounds, :column_bounds

  def initialize(input=nil)
    @input = input || real_input
    @depths = Hash.new(:out_of_bounds)
    parse_input
  end

  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.part1 #=> 15
  def part1
    lowest_points
      .values
      .map{ |low_point| low_point + 1 }
      .reduce(&:+)
  end

  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.part2 #=> 1134
  def part2
    basins
      .map{ |b| b.length }
      .sort[-3..-1]
      .reduce(&:*)
  end

  def basins
    @basins ||= lowest_points
      .map {|location, _depth|
        survey_basin(location)
      }
  end

  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.survey_basin([0,1]) #=> Set.new([[0,0],[0,1],[1,0]])
  def survey_basin(location)
    basin = Set.new.add(location)
    survey = [location]
    while check_loc = survey.pop
      if depths[check_loc] != 9
        adjacent_locations(check_loc)
          .reject { |neighbor| depths[neighbor] == :out_of_bounds }
          .each do |neighbor|
            if !basin.include?(neighbor)
              basin << neighbor if depths[neighbor] != 9
              survey.unshift(neighbor)
            end
          end
      end
    end
    basin
  end

  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.lowest_points #=> {[0, 1]=>1, [0, 9]=>0, [2, 2]=>5, [4, 6]=>5}
  def lowest_points
    @lowest_points ||= depths
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

  # Updates @depths with values from input
  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.parse_input
  #   d.row_bounds #=> (0..4)
  #   d.row_bounds.cover?(4) #=> true
  #   d.column_bounds #=> (0..9)
  #   d.column_bounds.cover?(10) #=> false
  def parse_input
    input
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index{ |row, r|
        row.each_with_index{ |measured_depth, c|
          depths[[r,c]] = measured_depth
        }
      }

    @row_bounds,
    @column_bounds = depths
      .keys
      .transpose
      .map{ |dimension| Range.new(*dimension.minmax) }
  end

  # Print lowest points or basins?
  #
  # @example
  #   d = Day09.new(EXAMPLE_INPUT)
  #   d.display_heightmap
  #   d.display_heightmap(:basins)
  def display_heightmap(type = :lowest_points)
    puts
    @row_bounds.each do |row|
      @column_bounds.each do |column|
        depth = depths[[row,column]]
        case type
        when :lowest_points
          if lowest_points.keys.include?([row,column])
            print "\e[7m#{depth}\e[0m"
          else
            print depth
          end
        when :basins
          if basins.map{|b| b.include? [row,column]}.any?
            print "\e[7m#{depth}\e[0m"
          else
            print "\e[35m#{depth}\e[0m"
          end
        else
          puts "I don't know how to print #{type}."
        end
      end
      puts
    end
    puts
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
