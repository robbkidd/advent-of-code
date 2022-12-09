class Day03 < Day

  PRIORITIES = [:dont_be_off_by_one] + ('a'..'z').to_a + ('A'..'Z').to_a

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

  # @example
  #   day.part2 #=> 70
  def part2
    @input
      .split("\n")
      .map{ |line| line.chars }
      .each_slice(3)
      .map { |group_items|
        group_items[0] & (group_items[1] & group_items[2])
      }
      .flatten
      .map{ |badge| PRIORITIES.index(badge) }
      .reduce(&:+)
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
