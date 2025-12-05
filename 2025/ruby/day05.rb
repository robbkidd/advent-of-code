require_relative 'day'

class Range
  # Patch the monkeys! Muahaha!
  #
  # @example 10-14, 12-18
  #   (10..14).combine (12..18) #=> (10..18)
  # @example 12-18, 16-20
  #   (16..20).combine (12..18) #=> (12..20)
  # @example 0..1, 8..9
  #   (0..1).combine (8..9) #=> raise RuntimeError, "Can't combine ranges that don't overlap: 0..1, 8..9"
  def combine(other)
    raise "Can't combine ranges that don't overlap: #{self}, #{other}" if !self.overlap?(other)
    Range.new([self.min, other.min].min, [self.max, other.max].max)
  end
end

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
          unique_ranges[hit] = unique_ranges[hit].combine input_range
        else
          unique_ranges << input_range
        end
      }
      .map(&:count)
      .reduce(&:+)
  end

  EXAMPLE_INPUT = File.read("../inputs/day05-example-input.txt")
end
