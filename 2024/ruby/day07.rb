require_relative 'day'

class Day07 < Day # >
  def initialize(*args)
    super
    @equations =
      input
        .split("\n")
        .map { |line| line.scan(/\d+/).map(&:to_i) }
        .map { |nums| [ nums[0] , nums[1..-1] ] }
  end

  # @example
  #   day.part1 #=> 3749
  def part1
    operators = [:+, :*]
    @equations
      .select { |test_value, operands|
        operators
          .repeated_permutation(operands.length - 1)
          .find { |combo|
            test_value ==
              combo
                .each_with_index
                .reduce(operands[0]) { |result, (op, idx)|
                  result = [ result, operands[idx+1] ].reduce(op)
                }
          }
      }
      .map { |test_value, _| test_value }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 11387
  def part2
    operators = [:+, :*, :concat]
    @equations
      .select { |test_value, operands|
        operators
          .repeated_permutation(operands.length - 1)
          .find { |combo|
            test_value ==
              combo
                .each_with_index
                .reduce(operands[0]) { |result, (op, idx)|
                  result = [ result, operands[idx+1] ].reduce(op)
                }
          }
      }
      .map { |test_value, _| test_value }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = File.read("../inputs/day07-example-input.txt")
end

class Integer
  # @example
  #   12.concat(345) #=> 12345
  def concat(other)
    "#{self}#{other}".to_i
  end
end
