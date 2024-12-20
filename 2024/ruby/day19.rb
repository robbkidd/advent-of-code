require_relative 'day'

class Day19 < Day # >

  # @example
  #   day.part1 #=> 6
def part1
  towels, designs = input.split("\n\n")
  towel_matcher = Regexp.new(/\A(#{towels.gsub(", ", "|")})+\z/)
  desired_designs = designs.split("\n")
  desired_designs.count { |pattern| pattern.match?(towel_matcher) }
end

  # @example
  #   day.part2 #=> 16
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day19-example-input.txt")
end
