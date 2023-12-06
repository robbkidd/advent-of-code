require_relative 'day'
require 'parallel'

class Day06 < Day # >

  # @example
  #   day.part1 #=> 288
  def part1
    input
      .each_line
      .map { |line| line.scan(/\d+/).map(&:to_i) }
      .transpose
      .map {|time, record_distance|
        1.upto(time)
          .select { |hold| hold * (time-hold) > record_distance }
          .count
      }
      .reduce(&:*)
  end

  # @example
  #   day.part2 #=> 71503
  def part2
    time, record_distance = input
                              .each_line
                              .map { |line| line.scan(/\d+/).join('').to_i }

    1.upto(time)
      .select { |hold| hold * (time-hold) > record_distance }
      .count
  end

  EXAMPLE_INPUT = <<~INPUT
    Time:      7  15   30
    Distance:  9  40  200
  INPUT
end
