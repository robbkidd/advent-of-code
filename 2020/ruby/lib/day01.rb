class Day01
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    ExpenseAudit.new(load_expenses).which_pair_is_2020.reduce(:*)
  end

  def self.part2
    ExpenseAudit.new(load_expenses).which_triplet_is_2020.reduce(:*)
  end

  def self.load_expenses
    File.read('../inputs/day01-input.txt').split("\n").map(&:to_i)
  end
end

class ExpenseAudit
  def initialize(expenses = [])
    @expenses = expenses
  end

  def which_pair_is_2020
    @expenses.combination(2).select { |a, b| a + b == 2020 }.first
  end

  def which_triplet_is_2020
    @expenses.combination(3).select { |triplet| triplet.reduce(:+) == 2020 }.first
  end
end

