require_relative 'day'

class Day02 < Day # >

  # @example
  #   day.part1 #=> 2
  def part1
    parsed_input
      .count { |report| safe?(report) }
  end

  # @example
  #   day.part2 #=> 4
  def part2
    parsed_input
      .count { |report| safe_with_problem_dampener?(report) }
  end

  # @example 7,6,4,2,1
  #   day.safe?([7,6,4,2,1]) #=> true
  # @example 1,2,7,8,9
  #   day.safe?([1,2,7,8,9]) #=> false
  # @example 1,3,2,4,5
  #   day.safe?([1,3,2,4,5]) #=> false
  def safe?(report)
    direction = report[0] <=> report[-1] # the report's starting level should be
    return false if direction == 0       # different than the ending level

    report
      .each_cons(2) do |left, right|
        return false unless delta_ok?(direction, left, right)
      end

    true
  end

  def delta_ok?(direction, left, right)
    (left <=> right) == direction &&   # "The levels are either all increasing or all decreasing." i.e matches start/end direction
      (left - right).abs.between?(1,3) # "Any two adjacent levels differ by at least one and at most three."
  end

  # @example 7,6,4,2,1
  #   day.safe_with_problem_dampener?([7,6,4,2,1]) #=> true
  # @example 1,2,7,8,9
  #   day.safe_with_problem_dampener?([1,2,7,8,9]) #=> false
  def safe_with_problem_dampener?(report)
    direction = report[0] <=> report[-1] # the report's starting level should be
    return false if direction == 0       # different than the ending level

    report
      .combination(report.length - 1) # all the variations of the report minus a level
      .any? { safe?(_1) }             # are any of them safe?
  end

  def parsed_input
    input
      .split("\n")
      .map { |line| line.scan(/\d+/).map(&:to_i) }
  end

  EXAMPLE_INPUT = <<~INPUT
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
  INPUT
end
