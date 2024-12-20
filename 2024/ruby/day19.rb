require_relative 'day'

class Day19 < Day # >

  def initialize(*args)
    super
    towels, designs = input.split("\n\n")
    @towel_patterns = towels.split(", ")
    @desired_designs = designs.split("\n")
    @design_cache = Hash.new(0)
  end

  # @example
  #   day.part1 #=> 6
  def part1
    towel_matcher = Regexp.new(/\A(#{@towel_patterns.join("|")})+\z/)
    @desired_designs.count { |pattern| pattern.match?(towel_matcher) }
  end

  # @example
  #   day.part2 #=> 16
  def part2
    @desired_designs.inject(0) do |count, design|
      count += ways_to_make_design(design)
    end
  end

  # @example
  #   day.ways_to_make_design("brwrr") #=> 2
  #   day.ways_to_make_design("bggr") #=> 1
  #   day.ways_to_make_design("gbbr") #=> 4
  def ways_to_make_design(design)
    return @design_cache[design] if @design_cache[design] > 0
    return 1 if design.empty?

    @design_cache[design] =
      @towel_patterns.reduce(0) { |ways, towel|
        ways += design.end_with?(towel) ? ways_to_make_design(design[..(-(towel.length+1))]) : 0
      }
  end

  EXAMPLE_INPUT = File.read("../inputs/day19-example-input.txt")
end
