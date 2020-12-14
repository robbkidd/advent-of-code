class Day14
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    computer = SeaPortComputer.new
    computer.program_init
    computer.check_sum
  end

  def part2
  end

  def self.example_input
    <<~EXAMPLE
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
    EXAMPLE
  end
end

class SeaPortComputer
  attr_accessor :memory, :mask, :raw_mask

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day14-input.txt")).split("\n")
    @memory = Hash.new(0)
    @mask = nil
  end

  def check_sum
    memory.values.reduce(&:+)
  end

  def program_init
    parse_input.each do |command, args|
      self.send(command, args)
    end
  end

  def parse_input
    @input.map do |line|
      case line
      when /^mask = (.*)$/
        [:set_mask, $1]
      when /^\s*mem\[(\d+)\] = (.*)$/
        [:set_mem, [$1.to_i, $2.to_i]]
      end
    end
  end

  def set_mask(mask)
    @mask = mask.split('')
                .each_with_index
                .inject({}) do |mask, (bit, idx)|
                  mask[idx] = bit if bit != "X"
                  mask
                end
  end

  def set_mem(args)
    address, value = *args
    expanded_value = value.to_s(2).rjust(36, "0").split('')
    mask.each { |idx, bit| expanded_value[idx] = bit }
    memory[address] = expanded_value.join("").to_i(2)
  end
end