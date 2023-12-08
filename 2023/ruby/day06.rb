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
    # part2_map_reduce
    part2_split
  end

  def part2_map_reduce
    time, record_distance = input_part2

    1.upto(time)
      .select { |hold| hold * (time-hold) > record_distance }
      .count
  end

  def part2_split
    time, record_distance = input_part2

    [
      (time/2+1).upto(time),
      (time/2).downto(1)
    ]
    .map { |times|
      Thread.new {
        wins = 0
        times
          .each do |hold|
            if hold * (time-hold) > record_distance
              wins += 1
            elsif wins > 0
              break
            end
          end
        wins
      }
    }
    .map(&:value)
    .reduce(&:+)
  end

  def input_part2
    @input_part2 ||=
      input
        .each_line
        .map { |line| line.scan(/\d+/).join('').to_i }
  end

  EXAMPLE_INPUT = <<~INPUT
    Time:      7  15   30
    Distance:  9  40  200
  INPUT
end
