class Day04 < Day

  # @example
  #   day.part1 #=> 2
  def part1
    input_as_ranges
      .select { |assign_a, assign_b|
        assign_a.cover?(assign_b) || assign_b.cover?(assign_a)
      }
      .count
  end

  # @example
  #   day.part2 #=> 4
  def part2
    input_as_ranges
      .select { |assign_a, assign_b|
        (assign_a.to_a & assign_b.to_a).any?
      }
      .count
  end

  def input_as_ranges
    @as_ranges ||= @input
      .split("\n")
      .map { |line| line.split(",") }
      .map { |pair| 
        pair
          .map{ |elf| elf.split("-").map(&:to_i)}
          .map{ |start, stop| Range.new(start,stop) }
      }
  end

  EXAMPLE_INPUT = <<~INPUT
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
  INPUT
end
