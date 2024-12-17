require_relative 'day'
require_relative 'grid'
require 'set'

class Day12 < Day # >

  # @example
  #   day.part1 #=> 1930
  # @example first
  #   day = new(EXAMPLE_FIRST)
  #   day.part1 #=> 140
  def part1
    find_regions(Grid.new(input).parse)
      .map {|region|
        puts "\n" + region.to_s {|_,v| v == :out_of_bounds ? ' ' : v} if ENV['DEBUG']
        [ region.count , # area
          region
            .map { |loc, _| 4 - region.neighbors_for(loc).count } # perimeter
            .reduce(&:+)
        ]
      }
      .map { |area, perimeter| area * perimeter}
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  def find_regions(garden_map)
    regions = []
    surveyed = Set.new
    garden_map
      .each do |location, _crop|
        next if surveyed.include?(location)

        survey = Hash.new
        survey_queue = [location]
        while check_loc = survey_queue.pop
          current_crop = garden_map.at(check_loc)
          survey.store(check_loc, current_crop)
          garden_map
            .neighbors_for(check_loc)
            .reject { |_, neighbor| survey.include?(neighbor) }
            .select { |_, neighbor| garden_map.at(neighbor) == current_crop}
            .each { |_, neighbor|
              survey_queue << neighbor
            }
        end
        surveyed.merge(survey.keys)
        regions << Grid.new(survey)
      end
    regions
  end

  EXAMPLE_INPUT = File.read("../inputs/day12-example-input.txt")

  EXAMPLE_FIRST = <<~FIRST
    AAAA
    BBCD
    BBCC
    EEEC
  FIRST
end
