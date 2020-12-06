class Day06
  def self.go
    day = new
    puts "Part1: #{day.part1}"
    puts "Part2: #{day.part2}"
  end

  def initialize(input = nil)
    @input = input || File.read("../inputs/#{self.class.name.downcase}-input.txt")
  end

  def input
    @input.split("\n\n").map{ |group| group.split("\n") }
  end

  def part1
    input.map{ |group| group.join('').split('').sort.uniq.count }
         .reduce(:+)
  end

  def part2
    input.map{ |group| group.map{|a| a.split('')}.reduce(:&).length }
         .reduce(:+)
  end
end
