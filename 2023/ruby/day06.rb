require_relative 'day'

class Day06 < Day # >

  # @example
  #   day.part1 #=> 288
  def part1
    input
      .each_line
      .map { |line| line.split(/\s+/)[1..].map(&:to_i) }
      .transpose
      .map {|time, record_distance|
        1.upto(time)
          .select { |hold_time| hold_time * (time-hold_time) > record_distance }
          .count
      }
      .reduce(&:*)
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    Time:      7  15   30
    Distance:  9  40  200
  INPUT
end
