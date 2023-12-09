require_relative 'day'

class Day09 < Day # >

  # @example
  #  day.oasis_report #=> [[0, 3, 6, 9, 12, 15], [1, 3, 6, 10, 15, 21], [10, 13, 16, 21, 30, 45]]
  def oasis_report
    @oasis_report ||=
      input
        .each_line
        .map { |line| line.split(" ").map(&:to_i) }
  end

  # @example
  #   day.part1 #=> 114
  def part1
    oasis_report
      .map { |history|
        sequences = [history]
        while !sequences.last.all?(0) do
          sequences << sequences.last.each_cons(2).map { |a,b| b - a }
        end                                 #                  ^^^^^
        sequences.map(&:last).reduce(&:+)   # <--- last and next-minus-prev
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 2
  def part2
    oasis_report
      .map { |history|
        sequences = [history]
        while !sequences.last.all?(0) do
          sequences << sequences.last.each_cons(2).map { |a,b| a - b }
        end                                 #                  ^^^^^
        sequences.map(&:first).reduce(&:+)  # <--- first and prev-minus-next
      }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = <<~INPUT
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  INPUT
end
