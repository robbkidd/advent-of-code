class Day03
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def part1
    diag = SubDiagnostics.new(report)
    diag.power_consumption
  end

  def part2
  end

  def report
    File.read('../inputs/day03-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
  INPUT
end

class SubDiagnostics
  def initialize(report='')
    @report = report.split("\n")
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end

  def gamma_rate
    popular_bits
      .to_i(2)
  end

  def epsilon_rate
    popular_bits
      .tr('01', '10')
      .to_i(2)
  end

  def popular_bits
    @popular_bits ||= @report
      .map{ |line| line.chars }
      .transpose
      .map{ |position| position.tally }
      .map{ |tally| tally.max_by {|_bit, count| count }.first }
      .join("") 
  end
end

require 'minitest'

class TestDay03 < Minitest::Test
  def test_example_part1
    diag = SubDiagnostics.new(Day03::EXAMPLE_INPUT)
    assert_equal 22, diag.gamma_rate
    assert_equal 9, diag.epsilon_rate
    assert_equal 198, diag.power_consumption
  end
end

if ENV.key? 'TEST'
  require 'minitest/autorun'
else
  Day03.go
end
