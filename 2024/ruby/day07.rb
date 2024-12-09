require_relative 'day'

class Day07 < Day # >

  # @example
  #   day.part1 #=> 3749
  def part1
    input
      .split("\n")
      .map { |line| line.scan(/\d+/).map(&:to_i) }
      .map { |nums| [ nums[0] , nums[1..-1] ] }
      .select { |test_value, operands|
        operator_combos = [:+, :*].repeated_permutation(operands.length - 1)
        operator_combos.map { |combo|
          combo
            .each_with_index
            .reduce(operands[0]) { |result, (op, idx)|
              result = [ result, operands[idx+1] ].reduce(op)
            }
        }
        .any? { |result| result == test_value }
      }
      .map { |test_value, _| test_value }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 11387
  def part2
    input
      .split("\n")
      .map { |line| line.scan(/\d+/).map(&:to_i) }
      .map { |nums| [ nums[0] , nums[1..-1] ] }
      .select { |test_value, operands|
        operator_combos = [:+, :*, :concat].repeated_permutation(operands.length - 1)
        operator_combos.map { |combo|
          combo
            .each_with_index
            .reduce(operands[0]) { |result, (op, idx)|
              result = [ result, operands[idx+1] ].reduce(op)
            }
        }
        .any? { |result| result == test_value }
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
