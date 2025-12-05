require_relative 'day'

class Day03 < Day # >

  # @example
  #   day.part1 #=> 357
  def part1
    @input
      .split("\n")
      .map { |line| max_joltage(line) }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 3121910778619
  def part2
    @input
      .split("\n")
      .map { |line| max_joltage(line, joltage_limit_safety_override: true) }
      .reduce(&:+)
  end

  # @example
  #   day.max_joltage("987654321111111") #=> 98
  #   day.max_joltage("811111111111119") #=> 89
  #   day.max_joltage("234234234234278") #=> 78
  #   day.max_joltage("818181911112111") #=> 92
  # @example with override
  #   day.max_joltage("987654321111111", joltage_limit_safety_override: true) #=> 987654321111
  #   day.max_joltage("811111111111119", joltage_limit_safety_override: true) #=> 811111111119
  #   day.max_joltage("234234234234278", joltage_limit_safety_override: true) #=> 434234234278
  #   day.max_joltage("818181911112111", joltage_limit_safety_override: true) #=> 888911112111
  def max_joltage(input_line, joltage_limit_safety_override: false)
    bank = input_line.split("").map(&:to_i)

    batteries = []
    idx = -1
    active_battery_limit = joltage_limit_safety_override ? 12 : 2

    active_battery_limit.downto(0).each do |within|
      jolts, idx = max_within(bank, idx+1, within)
      batteries << jolts
    end

    batteries.join("").to_i
  end

  # @example
  #   bank = [8,1,1,1,1,1,1,1,1,1,1,9]
  #   day.max_within(bank, 0, 2) #=> [8, 0]
  #   day.max_within(bank, 1, 1) #=> [9, 11]
  def max_within(bank, start, within)
    joltage = -1
    idx = start
    bank[start..(-within)].each_with_index do |batt, i|
      if batt > joltage
        joltage = batt
        idx = (start + i)
      end
    end
    [joltage, idx]
  end

  def parse_input
    @input
      .split("\n")
      .map { |line| line.scan(/\d/).map(&:to_i) }
  end

  EXAMPLE_INPUT = File.read("../inputs/day03-example-input.txt")
end
