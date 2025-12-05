require_relative 'day'

class Day02 < Day # >

  # @example
  #   day.part1 #=> 1227775554
  def part1
    ranges = parse_input
    invalid_ids = []

    ranges.each do |range|
      range.each do |id|
        invalid_ids << id if repeats_twice?(id)
      end
    end

    invalid_ids
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 4174379265
  def part2
    ranges = parse_input
    invalid_ids = []

    ranges.each do |range|
      range.each do |id|
        invalid_ids << id if repeats_at_least_twice?(id)
      end
    end

    invalid_ids
      .reduce(&:+)
  end


  def repeats_twice?(id)
    id_str = id.to_s
    return false if id_str.length.odd?
    return true if id_str[0...(id_str.length/2)] == id_str[(id_str.length/2)..]
    false
  end

  # @example 11
  #   day.repeats_at_least_twice? 11 #=> true
  # @example 22
  #   day.repeats_at_least_twice? 22 #=> true
  # @example 99
  #   day.repeats_at_least_twice? 99 #=> true
  # @example 111
  #   day.repeats_at_least_twice? 111 #=> true
  # @example 999
  #   day.repeats_at_least_twice? 999 #=> true
  # @example 1010
  #   day.repeats_at_least_twice? 1010 #=> true
  # @example 565656
  #   day.repeats_at_least_twice? 565656 #=> true
  # @example 824824824
  #   day.repeats_at_least_twice? 824824824 #=> true
  def repeats_at_least_twice?(id)
    id_str = id.to_s
    (id_str + id_str)[1..-2].include?(id_str)
  end

  # @example
  #   day = Day02.new(EXAMPLE_INPUT)
  #   parsed = day.parse_input
  #   parsed.first #=> (11..22)
  def parse_input
    @input
      .split(",")
      .map { |range|
        Range.new(*(range.split("-").map(&:to_i)))
      }
  end

  EXAMPLE_INPUT = File.read("../inputs/day02-example-input.txt")
end
