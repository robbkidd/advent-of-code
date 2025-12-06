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
      .map {|line| line.scan(/\S+/)} # 2D of human numbers, last array is operators (all still strings)
      .cheater_transpose             # transposed, now each array represents a worksheet problem (column)
      .map { |problem|
        operator = problem.pop       # problem's operator appears as the last element of the problem array
        problem
          .map(&:to_i)               # string of human number to integer
          .reduce(&operator.to_sym)  # solve this problem
      }
      .reduce(&:+)                   # sum of all problem solutions
  end

  # @example
  #   day.part2 #=> 3263827
  def part2
    input
      .split("\n")
      .map { |line| line.chars }     # 2D of characters from the input
      .cheater_transpose             # transposed, now each array is a column of characters from the worksheet
      .chunk { |col| col.all? " "}   # group problem columns together by chunking on empties ...
      .map { |split, problem|        # ... chunks that are empty are noted as split
        next 0 if split              # skip the splits
        operator = problem.first.pop # problem's operator appears as the last character in the first column
        problem
          .map(&:join)               # recreate a string of the digits (read vertically by the earlier transpose)
          .map(&:to_i)               # make it a number (cephalopod number)
          .reduce(&operator.to_sym)  # solve this problem
      }
      .reduce(&:+)                   # sum of all problem solutions
  end

  EXAMPLE_INPUT = File.read("../inputs/day06-example-input.txt")
end
