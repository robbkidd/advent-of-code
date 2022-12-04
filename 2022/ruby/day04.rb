class Day04
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example
  #   day.part1 => 2
  def part1
    input_as_ranges
      .map { |assign_a, assign_b|
        assign_a.cover?(assign_b) || assign_b.cover?(assign_a)
      }
      .select {|fully_contains| fully_contains == true }
      .count
  end

  def part2
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

  def real_input
    File.read('../inputs/day04-input.txt')
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
