require_relative 'day'

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
    @scan_cache = Hash.new
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
  #   ♨️ = new("???.### 1,1,3")
  #   ♨️.rows.map { ♨️.scan(*_1) }.first #=> 1
  #   ♨️.unfold.map{ new.scan(*_1) }.first #=> 1
  #
  # @example 2nd row
  #   ♨️ = new(".??..??...?##. 1,1,3")
  #   ♨️.rows.map { ♨️.scan(*_1) }.first #=> 4
  #   ♨️.unfold.map{ new.scan(*_1) }.first #=> 16384
  #
  # @example 3rd row
  #   ♨️ = new("?#?#?#?#?#?#?#? 1,3,1,6")
  #   ♨️.rows.map { ♨️.scan(*_1) }.first #=> 1
  #   ♨️.unfold.map{ new.scan(*_1) }.first #=> 1
  #
  # @example 4th row
  #   ♨️ = new("????.#...#... 4,1,1")
  #   ♨️.rows.map { ♨️.scan(*_1) }.first #=> 1
  #   ♨️.unfold.map{ new.scan(*_1) }.first #=> 16
  #
  # @example 5th row
  #   ♨️ = new("????.######..#####. 1,6,5")
  #   ♨️.rows.map { ♨️.scan(*_1) }.first #=> 4
  #   ♨️.unfold.map{ new.scan(*_1) }.first #=> 2500
  #
  # @example 6th row
  #   ♨️ = new("?###???????? 3,2,1")
  #   ♨️.rows.map { ♨️.scan(*_1) }.first #=> 10
  #   ♨️.unfold.map{ new.scan(*_1) }.first #=> 506250
  def scan(springs, counts, previous_maybe_damaged=false)
    return @scan_cache.fetch([springs, counts, previous_maybe_damaged]) { |key|
      @scan_cache[key] =
        if counts.empty?
          # what's left shouldn't be damaged if the trusted counts say there are no more damaged springs
          springs.include?(DAMAGED) ? 0 : 1

        elsif springs.empty?
          # the trusted counts shouldn't say there are more damaged when we're out of springs to evaluate
          counts.reduce(&:+).positive? ? 0 : 1

        elsif counts[0] == 0
          maybe_working?(springs[0]) ? scan(springs[1..], counts[1..], false) : 0

        elsif previous_maybe_damaged
          maybe_damaged?(springs[0]) ? scan(springs[1..], ([counts[0]-1] + counts[1..]), true) : 0

        elsif springs[0] == DAMAGED
          scan(springs[1..], ([counts[0]-1] + counts[1..]), true)

        elsif springs[0] == WORKING
          scan(springs[1..], counts, false)

        else
          scan(springs[1..], counts, false) +           # run the scenarios where first spring is working
                  scan(springs[1..], ([counts[0]-1] + counts[1..]), true) # and the scenarios where first is/might-be broken
        end
    }
  end
end
