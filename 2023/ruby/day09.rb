require_relative 'day'

class Day09 < Day # >

  # @example
  #   day.part1 #=> 114
  def part1
    oasis_report
      .map { |value_history| next_in_sequence(value_history)}
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 2
  def part2
    oasis_report
      .map { |value_history| next_in_sequence(value_history.reverse)}
      .reduce(&:+)
  end

  def next_in_sequence(sequence)
    sequences = [sequence]
    until sequences.last.all?(0) do
      sequences << sequences.last.each_cons(2).map { |a,b| b - a }
    end
    sequences.map(&:last).reduce(&:+)
  end

  # @example
  #  day.oasis_report #=> [[0, 3, 6, 9, 12, 15], [1, 3, 6, 10, 15, 21], [10, 13, 16, 21, 30, 45]]
  def oasis_report
    @oasis_report ||=
      input
        .each_line
        .map { |line| line.split(" ").map(&:to_i) }
  end

  EXAMPLE_INPUT = <<~INPUT
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  INPUT
end
