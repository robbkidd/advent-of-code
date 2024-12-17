require_relative 'day'
require_relative 'grid'
require 'parallel'

class Day10 < Day # >

  attr_reader :trailheads, :peaks, :guide

  def initialize(*args)
    super
    @trailheads = []
    @peaks = []
    @guide = Grid.new(input)
    @guide
      .parse { |coords, char|
          case char
          when '0' ; trailheads << coords
          when '9' ; peaks << coords
          else ; # carry on
          end
          @guide.set(coords, (char == '.' ? Float::INFINITY : char.to_i))
        }
  end

  # @example
  #   day.part1 #=> 36
  def part1
    guide
      .set_step_cost_calculator { |grid, from_coords, to_coords|
        if grid.at(to_coords) == :out_of_bounds
          Float::INFINITY
        elsif 1 == grid.at(to_coords) - grid.at(from_coords)
          1
        else
          Float::INFINITY
        end
      }

    Parallel
      .map(trailheads) { |trailhead|
        peaks
          .map { |peak| guide.shortest_path_between(trailhead, peak) }
          .select { _1.length > 0 }
          .count
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 81
  def part2
    Parallel
      .map(trailheads) { |trailhead|
        rating = 0
        survey_queue = [trailhead]
        while check_pos = survey_queue.pop
          current_elevation = guide.at(check_pos)
          if current_elevation == 9
            rating += 1
          else
            guide
              .neighbors_for(check_pos)
              .select { |_, neighbor| guide.at(neighbor) == current_elevation + 1 }
              .each { |_, neighbor| survey_queue << neighbor }
          end
        end
        rating
      }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = File.read("../inputs/day10-example-input.txt")
end
