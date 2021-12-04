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
    diag = SubDiagnostics.new(report)
    diag.life_support_rating
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
    @report = report
      .split("\n")
      .map{ |line| line.chars }

    if 1 == @report.map { |line| line.length }.uniq.length
      @num_digits = @report.first.length
    else
      raise "Yea, these numbers don't seem to have the same length."
    end
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
    @popular_bits ||= 
      bit_tally(@report).map{ |tally| 
        tally.max_by {|_bit, count| count }.first 
      }.join("") 
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  def oxygen_generator_rating
    whittle = @report.dup
    (0..@num_digits-1).each do |position|
      bit_criteria = most_common_bit_at(whittle, position)
      whittle.select! do |bits|
        bits[position] == bit_criteria
      end
      break if 1 == whittle.length
    end
    whittle
      .first
      .join("")
      .to_i(2)
  end

  def co2_scrubber_rating
    whittle = @report.dup
    (0..@num_digits-1).each do |position|
      bit_criteria = least_common_bit_at(whittle, position)
      whittle.select! do |bits|
        bits[position] == bit_criteria
      end
      break if 1 == whittle.length
    end
    whittle
      .first
      .join("")
      .to_i(2)
  end

  def most_common_bit_at(input, position)
    bit_tally(input)[position]
      .tap { |t| t.delete("0") if t["0"] == t["1"]}
      .max_by { |_bit, count| count }
      .first
  end

  def least_common_bit_at(input, position)
    bit_tally(input)[position]
      .tap { |t| t.delete("1") if t["0"] == t["1"] }
      .min_by { |_bit, count| count }
      .first
  end
  
  def bit_tally(input)
    input
      .transpose
      .map{ |position| position.tally } 
  end
end

require 'minitest'

class TestDay03 < Minitest::Test

  def setup
    @diag = SubDiagnostics.new(Day03::EXAMPLE_INPUT) 
  end

  def test_part1_gamma_rate
    assert_equal 22, @diag.gamma_rate
  end

  def test_part1_epsilon_rate
    assert_equal 9, @diag.epsilon_rate
  end

  def test_part1_power_consumption
    assert_equal 198, @diag.power_consumption
  end

  def test_part2_oxygen_generator_rating
    assert_equal 23, @diag.oxygen_generator_rating
  end

  def test_part2_co2_scrubber_rating
    assert_equal 10, @diag.co2_scrubber_rating
  end

  def test_part2_life_support_rating
    assert_equal 230, @diag.life_support_rating
  end
end

if ENV.key? 'TEST'
  require 'minitest/autorun'
else
  Day03.go
end
