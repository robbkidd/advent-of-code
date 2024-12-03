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
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  INPUT
end
