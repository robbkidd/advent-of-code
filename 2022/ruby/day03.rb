class Day03
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  PRIORITIES = [nil] + ('a'..'z').to_a + ('A'..'Z').to_a

  # @example
  #   day.part1 #=> 157
  def part1
    @input
      .split("\n")
      .map{ |line| line.chars }
      .map{ |items| items
        .each_slice( (items.length/2.0).floor )
        .to_a
        .reduce(&:&)
      }
      .flatten
      .map{ |common_item| PRIORITIES.index(common_item) }
      .reduce(&:+)
  end

  def part2
  end

  def real_input
    File.read('../inputs/day03-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
  INPUT
end
