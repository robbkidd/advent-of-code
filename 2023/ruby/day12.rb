require_relative 'day'
require_relative 'ugly_sweater'

class Day12 < Day # >

  # @example
  #   day.part1 #=> 21
  def part1
    @hot_springs ||= HotSprings.new(input)

    @hot_springs
      .rows
      .map { |springs, damaged_counts|
        @hot_springs.scan(springs, damaged_counts)
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 525152
  def part2
    @hot_springs ||= HotSprings.new(input)

    @hot_springs
      .unfold
      .map { |even_more_springs, even_more_damaged_counts|
        @hot_springs.scan(even_more_springs, even_more_damaged_counts)
      }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = <<~INPUT
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
  INPUT
end

class HotSprings
  attr_reader :input, :rows

  def initialize(input="")
    @input = input
    @rows =
      @input
        .split("\n")
        .map { |line|
          springs, damaged_counts = line.split(" ")
          [
            springs,
            damaged_counts.split(",").map(&:to_i)
          ]
        }
  end

  # @example super simple
  #   new(".# 1").unfold #=> [ [".#?.#?.#?.#?.#", [1,1,1,1,1]] ]
  # @example 1st row
  #   new("???.### 1,1,3").unfold #=> [ ["???.###????.###????.###????.###????.###", [1,1,3,1,1,3,1,1,3,1,1,3,1,1,3]] ]
  def unfold
    rows
      .map { |springs, damaged_counts|
        [
          ([springs] * 5).join("?"),
          damaged_counts * 5,
        ]
      }
  end

  WORKING = "."
  DAMAGED = "#"
  UNKNOWN = "?"

  def maybe_working?(spring)
    [UNKNOWN, WORKING].include?(spring)
  end

  def maybe_damaged?(spring)
    [UNKNOWN, DAMAGED].include?(spring)
  end

  # @example 1st row
  #   new.scan("???.###", [1,1,3]) #=> 1
  #
  # @example 2nd row
  #   new.scan(".??..??...?##.", [1,1,3]) #=> 4
  #
  # @example 3rd row
  #   new.scan("?#?#?#?#?#?#?#?", [1,3,1,6]) #=> 1
  #
  # @example 4th row
  #   new.scan("????.#...#...", [4,1,1]) #=> 1
  #
  # @example 5th row
  #   new.scan("????.######..#####.", [1,6,5]) #=> 4
  #
  # @example 6th row
  #   new.scan("?###????????", [3,2,1]) #=> 10
  def scan(springs, counts, previous_maybe_damaged=false)
    # what's left shouldn't be damaged if the trusted counts say there are no more damaged springs
    return (springs.include?(DAMAGED) ? 0 : 1) if counts.empty?

    # the trusted counts shouldn't say there are more damaged when we're out of springs to evaluate
    return (counts.reduce(&:+).positive? ? 0 : 1) if springs.empty?

    # OK, we gotta compute stuff ...

    current_spring, remaining_springs = springs[0], springs[1..]
    current_count, remaining_counts = counts[0], counts[1..]
    decremented_counts = ([current_count-1] + remaining_counts)

    case
    when current_count == 0
      return maybe_working?(current_spring) ? scan(remaining_springs, remaining_counts, false) : 0

    when previous_maybe_damaged
      return maybe_damaged?(current_spring) ? scan(remaining_springs, decremented_counts, true) : 0

    when current_spring == DAMAGED
      return scan(remaining_springs, decremented_counts, true)

    when current_spring == WORKING
      return scan(remaining_springs, counts, false)

    else
      return scan(remaining_springs, counts, false) +           # run the scenarios where first spring is working
              scan(remaining_springs, decremented_counts, true) # and the scenarios where first is/might-be broken
    end
  end
end
