require_relative 'intcode'

class Day05
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    ship_computer = Intcode.new(program: test_diagnostic_program, input: [1])
    ship_computer.run
    ship_computer.output
  end

  def self.part2
    ship_computer = Intcode.new(program: test_diagnostic_program, input: [5])
    ship_computer.run
    ship_computer.output
  end

  def self.test_diagnostic_program
    File.read('../inputs/day05-input.txt').chomp.split(",").map(&:to_i)
  end
end
