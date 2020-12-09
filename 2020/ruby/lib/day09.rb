class Day09
  attr_reader :input

  def self.go
    day = new
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    data = XMAS.new
    data.first_invalid
  end

  def part2
  end
end

class XMAS
  attr_reader :data, :preamble

  def initialize(input = nil, preamble = 25)
    @input = input || File.read("../inputs/day09-input.txt")
    @data = parse_input(@input)
    @preamble = preamble
  end

  def parse_input(input)
    input.split("\n").map(&:to_i)
  end

  def first_invalid
    scan_pointer = preamble
    while valid_data_at?(scan_pointer) && scan_pointer < data.length
      scan_pointer += 1
    end

    if scan_pointer < data.length
      data[scan_pointer]
    else
      nil
    end
  end

  def valid_data_at?(pointer)
    data[(pointer-preamble)..(pointer-1)]
      .combination(2)
      .map{ |pair| pair.reduce(:+) }
      .include? data[pointer]
  end
end