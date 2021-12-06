class Day03
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example
  #   new(EXAMPLE_INPUT).part1 #=> 198
  #
  def part1
    diag = SubDiagnostics.new(@input)
    diag.power_consumption
  end

  # @example
  #   new(EXAMPLE_INPUT).part2 #=> 230
  #
  def part2
    diag = SubDiagnostics.new(@input)
    diag.life_support_rating
  end

  def real_input
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

  # @example
  #   SubDiagnostics
  #     .new(Day03::EXAMPLE_INPUT)
  #     .power_consumption #=> 198
  def power_consumption
    gamma_rate * epsilon_rate
  end

  # @example
  #   SubDiagnostics
  #     .new(Day03::EXAMPLE_INPUT)
  #     .gamma_rate #=> 22
  def gamma_rate
    popular_bits
      .to_i(2)
  end

  # @example
  #   SubDiagnostics
  #     .new(Day03::EXAMPLE_INPUT)
  #     .epsilon_rate #=> 9
  def epsilon_rate
    popular_bits
      .tr('01', '10')
      .to_i(2)
  end

  def popular_bits
    @popular_bits ||=
      bit_tally(@report)
        .map{ |tally|
          tally
            .max_by {|_bit, count| count }
            .first
        }
        .join("")
  end

  # @example
  #   SubDiagnostics
  #     .new(Day03::EXAMPLE_INPUT)
  #     .life_support_rating #=> 230
  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end

  # @example
  #   SubDiagnostics
  #     .new(Day03::EXAMPLE_INPUT)
  #     .oxygen_generator_rating #=> 23
  def oxygen_generator_rating
    rating_filter(method(:most_common_bit_at))
  end

  # @example
  #   SubDiagnostics
  #     .new(Day03::EXAMPLE_INPUT)
  #     .co2_scrubber_rating #=> 10
  def co2_scrubber_rating
    rating_filter(method(:least_common_bit_at))
  end

  def rating_filter(criteria_method)
    whittle = @report.dup
    (0..@num_digits-1).each do |position|
      bit_criterion = criteria_method.call(whittle, position)
      whittle.select! do |bits|
        bits[position] == bit_criterion
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
