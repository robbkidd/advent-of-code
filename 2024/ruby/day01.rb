require_relative 'day'

class Day01 < Day # >

  # @example
  #   day.part1 #=> 11
  def part1
    left, right = parsed_input

    left
      .sort
      .zip(right.sort)
      .map{ |l, r| (l - r).abs }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 31
  def part2
    left, right = parsed_input

    num_appearances_in_right_list = right.tally
    num_appearances_in_right_list.default = 0

    left
      .map {|left_num| left_num * num_appearances_in_right_list[left_num] }
      .reduce(&:+)
  end

  def parsed_input
    @parsed_input ||=
      input
        .split("\n")
        .map { |line| line.scan(/\d+/).map(&:to_i) }
        .transpose
  end

  EXAMPLE_INPUT = <<~INPUT
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
  INPUT
end
