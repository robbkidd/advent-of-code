class Day18
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}"
    puts "Part2: #{day.part2}"
  end

  def part1
    @input.map { |line| TheNewMath.solve(line) }
          .reduce(&:+)
  end

  def part2
  end

  def initialize
    @input = (input || File.read("../inputs/day18-input.txt")).split("\n")
  end

  def self.example_input
    <<~EXAMPLE
    EXAMPLE
  end
end

class TheNewMath
  attr_reader :input

  SIMPLE_EXPRESSION_REGEX = %r{(☾\d[^☾☽]*\d☽)}

  class << self
    def moonify(input)
      input.gsub(/\(/, "☾").gsub(/\)/, "☽")
    end

    def pluck_simple_expressions(expression)
      moonify(expression).scan(SIMPLE_EXPRESSION_REGEX).flatten(1)
    end

    def solve(input)
      expression = moonify(input)
      while expression.match?(/[☾☽]/) do
        pluck_simple_expressions(expression).each do |simple_expression|
          expression.gsub!(simple_expression, solve_left_to_right(simple_expression).to_s)
        end
      end
      solve_left_to_right(expression)
    end

    def solve_left_to_right(simple_expression)
      raise "No parens allowed inside." if simple_expression[1..-2].match?(/[☾☽]/)
      operands = simple_expression.scan(/\d+/).map(&:to_i)
      operators = simple_expression.scan(/(\+|\*)/).flatten.map(&:to_sym)
      start = operands.shift
      operations = operators.zip(operands)
      operations.reduce(start) {|acc, (opr, num)| acc.send(opr, num) }
    end
  end
end
