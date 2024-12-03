require_relative 'day'

class Day03 < Day # >

  # @example
  #   day.part1 #=> 161
  def part1
    input
      .scan(/mul\((\d{1,3}),(\d{1,3})\)/)
      .map { |params| params.map(&:to_i).reduce(&:*) }
      .reduce(&:+)
  end

  # @example
  #   day = Day03.new(EXAMPLE_INPUT_PART2)
  #   day.part2 #=> 48
  def part2
    input
      .scan(/(do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\))/)
      .each_with_object({mul_enabled: true, sum: 0}) { |(op, param1, param2), state|
        case op
        when "do()"    ; state[:mul_enabled] = true
        when "don't()" ; state[:mul_enabled] = false
        when /\Amul/   ; state[:sum] += (param1.to_i * param2.to_i) if state[:mul_enabled]
        else
          raise "lolwut: unexpected instruction [ #{op} , #{param1} , #{param2} ]"
        end
      }
      .fetch(:sum) # from each_with_object state hash
  end

  EXAMPLE_INPUT = File.read("../inputs/day03-example-input.txt")
  EXAMPLE_INPUT_PART2 = File.read("../inputs/day03-example-part2-input.txt")
end
