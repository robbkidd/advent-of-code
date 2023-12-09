require_relative 'day'

class Day09 < Day # >

  # @example
  #   day.part1 #=> 114
  def part1
    input
      .each_line
      .map { |line| line.split(" ").map(&:to_i) }
      .map { |history|
        sequences = [history]
        while !sequences.last.all?(0) do
          sequences << sequences.last.each_cons(2).map { |a,b| b - a }
        end
        sequences
          .reverse
          .map(&:last)
          .reduce(&:+)
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  INPUT
end
