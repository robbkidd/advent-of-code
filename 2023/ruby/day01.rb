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
  #   day.part2 #=> 'how are you'
  def part2
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

  EXAMPLE_INPUT = <<~INPUT
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
  INPUT
end
