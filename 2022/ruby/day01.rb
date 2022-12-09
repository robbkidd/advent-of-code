class Day01 < Day

  # @example
  #   day.part1 #=> 24_000
  def part1
    sorted_calorie_inventory
      .first
  end

  # @example
  #   day.part2 #=> 45_000
  def part2
    sorted_calorie_inventory[0..2].reduce(&:+)
  end

  def sorted_calorie_inventory
    @sorted_calorie_inventory ||= @input
      .split("\n\n")
      .map { |elf|
        elf
          .split("\n")
          .map(&:to_i)
          .reduce(&:+)
      }
      .sort
      .reverse
  end

  EXAMPLE_INPUT = <<~INPUT
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
  INPUT
end