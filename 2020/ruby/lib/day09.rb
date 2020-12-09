class Day09
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    data = XMAS.new
    data.first_invalid[:value]
  end

  def part2
    data = XMAS.new
    data.encryption_weakness
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

  def encryption_weakness
    invalid_data = first_invalid
    scan_upperbound = invalid_data[:index]
    target_sum = invalid_data[:value]

    scan_pointer = 0
    while scan_pointer < scan_upperbound
      contiguous_pointer = 0
      contiguous_sum = 0
      while target_sum > contiguous_sum
        contiguous_pointer +=1
        contiguous_range = scan_pointer..scan_pointer+contiguous_pointer
        contiguous_sum = data[contiguous_range].reduce(:+)
      end
      if contiguous_sum == target_sum
        sorted_values = data[scan_pointer..scan_pointer+contiguous_pointer].sort
        return sorted_values[0] + sorted_values[-1]
      else
        scan_pointer += 1
      end
    end
  end

  def first_invalid
    scan_pointer = preamble
    while valid_data_at?(scan_pointer) && scan_pointer < data.length
      scan_pointer += 1
    end

    if scan_pointer < data.length
      {
        index: scan_pointer,
        value: data[scan_pointer]
      }
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