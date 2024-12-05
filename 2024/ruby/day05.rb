require_relative 'day'

class Day05 < Day # >

  # @example
  #   day.part1 #=> 143
  def part1
    updates
      .select { correct_order? _1 }
      .map { |update| update[ (update.length/2).ceil ] }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 123
  def part2
    updates
      .reject { correct_order? _1 }
      .map { |update| fix(update)[ (update.length/2).ceil ] }
      .reduce(&:+)
  end

  # @example first
  #   day.correct_order?([75,47,61,53,29]) #=> true
  # @example fourth
  #   day.correct_order?([75,97,47,61,53]) #=> false
  def correct_order?(update)
    update
      .each_with_index { |page, idx|
        return false if rules[page].intersect?(update[0..idx])
      }
    true
  end

  # @example fourth
  #   day.fix([75,97,47,61,53]) #=> [97,75,47,61,53]
  # @example fifth
  #   day.fix([61,13,29]) #=> [61,29,13]
  # @example last
  #   day.fix([97,13,75,29,47]) #=> [97,75,47,29,13]
  def fix(update)
    update.sort { |x,y| rules[x].include?(y) ? -1 : 1 }
  end

  def rules
    @rules ||=
      input
        .split("\n\n")[0]
        .split("\n")
        .each_with_object(Hash.new {|h,k| h[k]=[]}) { |line, rules_hash|
          x, y = line.split("|").map(&:to_i)
          rules_hash[x].append(y)
        }
  end

  def updates
    @updates ||=
      input
        .split("\n\n")[1]
        .split("\n")
        .map { |line| line.split(",").map(&:to_i) }
  end

  EXAMPLE_INPUT = File.read("../inputs/day05-example-input.txt")
end
