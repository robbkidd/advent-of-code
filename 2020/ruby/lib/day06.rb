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
    @input.split("\n")
  end

  def part1
    input.chunk_while {|line| line != ""}
         .map{ |pass_answers| pass_answers.join('').split('').sort.uniq.count }
         .reduce(:+)
  end

  def part2
  end
end
