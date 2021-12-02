class Day01
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    ExpenseAudit.new(load_expenses).which_pair_is_2020.product()
  end

  def self.part2
    ExpenseAudit.new(load_expenses).which_triplet_is_2020.product()
  end

  def self.load_expenses
    File.read("../inputs/day01-input.txt").split("\n").map { |line| line.to_i }
  end
end

class ExpenseAudit
  def initialize(@expenses = [] of Int32)
  end

  def which_pair_is_2020
    @expenses.combinations(2).select { |pair| pair.sum() == 2020 }.first
  end

  def which_triplet_is_2020
    @expenses.combinations(3).select { |triplet| triplet.sum() == 2020 }.first
  end
end