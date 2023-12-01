require_relative 'day'

class Day01 < Day # >

  # @example
  #   day.part1 #=> 142
  def part1
    input
      .split("\n")
      .map{ |line| recover_calibration_value(line) }
      .reduce(:+)
  end

  # @example
  #   day = Day01.new(EXAMPLE_INPUT_PART_2)
  #   day.part2 #=> 281
  def part2
    input
      .split("\n")
      .map{ |line| recover_spelled_out_calibration_value(line) }
      .reduce(:+)
  end

  # @example
  #   day.recover_calibration_value('1abc2') #=> 12
  #   day.recover_calibration_value('pqr3stu8vwx') #=> 38
  #   day.recover_calibration_value('a1b2c3d4e5f') #=> 15
  #   day.recover_calibration_value('treb7uchet') #=> 77
  def recover_calibration_value(line)
    digits = line.scan(/\d/)
    [ digits[0], digits[-1] ].join().to_i
  end

  # @example
  #   day.recover_spelled_out_calibration_value('two1nine') #=> 29
  #   day.recover_spelled_out_calibration_value('eightwothree') #=> 83
  #   day.recover_spelled_out_calibration_value('abcone2threexyz') #=> 13
  #   day.recover_spelled_out_calibration_value('xtwone3four') #=> 24
  #   day.recover_spelled_out_calibration_value('4nineeightseven2') #=> 42
  #   day.recover_spelled_out_calibration_value('zoneight234') #=> 14
  #   day.recover_spelled_out_calibration_value('zoneightkjhsdf') #=> 18
  #   day.recover_spelled_out_calibration_value('7pqrstsixteen') #=> 76
  #   day.recover_spelled_out_calibration_value('twone') #=> 21
  def recover_spelled_out_calibration_value(line)
    recover_calibration_value(
      line.tap { |l| WORDS_TO_DIGITS.each {|w,d| l.gsub!(w, d) } }
    )
  end

  WORDS_TO_DIGITS = {
    'one' => 'o1e',
    'two' => 't2o',
    'three' => 't3e',
    'four' => 'f4r',
    'five' => 'f5e',
    'six' => 's6x',
    'seven' => 's7n',
    'eight' => 'e8t',
    'nine' => 'n9e',
  }

  EXAMPLE_INPUT = <<~INPUT
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
  INPUT

  EXAMPLE_INPUT_PART_2 = <<~INPUT
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
  INPUT
end
