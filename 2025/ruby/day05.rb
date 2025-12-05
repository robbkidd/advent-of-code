require_relative 'day'

class Day05 < Day # >
  attr_reader :ranges, :ids

  def initialize(input=nil)
    super
    ranges_in, ids_in = input().split("\n\n")

    @ranges =
      ranges_in
        .split("\n")
        .map { |line| Range.new(*(line.split("-").map(&:to_i))) }

    @ids = ids_in.split("\n").map(&:to_i)
  end

  # @example
  #   day.part1 #=> 3
  def part1
    ids
      .select { |id|
        ranges.find { |range| range.cover? id }
      }
      .count
  end

  # @example
  #   day.part2 #=> 14
  def part2
    ranges
      .sort_by { _1.min }
      .each_with_object([]) { |input_range, unique_ranges|
        if hit = unique_ranges.find_index { |uniq| uniq.overlap? input_range }
          unique_ranges[hit] = combine_ranges(unique_ranges[hit], input_range)
        else
          unique_ranges << input_range
        end
      }
      .map(&:count)
      .reduce(&:+)
  end

  # @example 10-14, 12-18
  #   day.combine_ranges((10..14), (12..18)) #=> (10..18)
  # @example 12-18, 16-20
  #   day.combine_ranges((16..20), (12..18)) #=> (12..20)
  def combine_ranges(a,b)
    Range.new([a.min, b.min].min, [a.max, b.max].max)
  end

  EXAMPLE_INPUT = File.read("../inputs/day05-example-input.txt")
end
