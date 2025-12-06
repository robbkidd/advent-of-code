require_relative 'day'

class Array
  # Patch more monkeys!

  # when you want to transpose a 2D array of unequal dimensions
  # works so long as the first array length is equal to the longest length
  def cheater_transpose
    self.first.zip(*self[1..])
  end
end

class Day06 < Day # >
  attr_reader :problems

  # @example
  #   day.part1 #=> 4277556
  def part1
    input
      .split("\n")
      .map {|line| line.scan(/\S+/)}
      .cheater_transpose
      .map { |problem|
        operator = problem.pop
        problem
          .map(&:to_i)
          .reduce(&operator.to_sym)
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 3263827
  def part2
    input
      .split("\n")
      .map { |line| line.chars }
      .cheater_transpose
      .chunk { _1.all? " "} # mark empty columns as 'split'
      .map { |split, problem|
        next 0 if split
        operator = problem.first.pop
        problem
          .map(&:join)
          .map(&:to_i)
          .reduce(&operator.to_sym)
      }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = File.read("../inputs/day06-example-input.txt")
end
