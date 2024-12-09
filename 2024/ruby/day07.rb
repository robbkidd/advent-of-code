require_relative 'day'

class Day07 < Day # >
  def initialize(*args)
    super
    @equations =
      input
        .split("\n")
        .map { |line| CalibrationEquation.new(line) }
  end

  # @example
  #   day.part1 #=> 3749
  def part1
    @equations
      .select{ _1.possibly_true([:+, :*]) }
      .map(&:test_value)
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 11387
  def part2
    @equations
      .select{ _1.possibly_true([:+, :*, :concat]) }
      .map(&:test_value)
      .reduce(&:+)
  end

  class CalibrationEquation
    attr_reader :test_value, :operands

    # @example
    #   e = new("190: 10 19")
    #   e.test_value #=> 190
    #   e.operands   #=> [10, 19]
    def initialize(input)
      @test_value, *@operands =
        input
          .scan(/\d+/)
          .map(&:to_i)
    end

    def possibly_true(operators)
      operators
        .repeated_permutation(operands.length - 1)
        .find { |combo|
          test_value == eval_with_operators(combo)
        }
    end

    def eval_with_operators(operator_combo)
      operator_combo
        .each_with_index
        .reduce(operands[0]) { |result, (op, idx)|
          result = [ result, operands[idx+1] ].reduce(op)
        }
    end
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
