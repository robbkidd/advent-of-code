require_relative 'intcode'

class Day09
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    boost_test = Intcode.new(program: load_boost_program, input: [1])
    boost_test.run
    boost_test.output
  end

  def self.part2
    boost_test = Intcode.new(program: load_boost_program, input: [2], debug: true)
    boost_test.run
    boost_test.output
  end

  def self.load_boost_program
    File.read('../inputs/day09-input.txt').chomp.split(",").map(&:to_i)
  end
end
