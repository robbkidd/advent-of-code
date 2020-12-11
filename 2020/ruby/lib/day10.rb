class Day10
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    chain = AdapterChain.new
    chain.joltage_differences
         .values
         .reduce(:*)
  end

  def part2
  end
end

class AdapterChain
  attr_reader :adapters

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day10-input.txt"))
               .split("\n")
               .map(&:to_i)
    @adapters = @input.sort
    @adapters.unshift(0)
    @adapters << @adapters[-1] + 3
  end

  def joltage_differences
    adapters.each_cons(2)
            .map { |p,n| n-p }
            .inject(Hash.new(0)) { |h, diff| h[diff] += 1 ; h }
  end
end