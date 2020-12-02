class Day02
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    passwords = load_passwords.map { |p| PasswordEntry.new(p) }
    passwords.inject(0) { |valid_count, p| valid_count += (p.valid? ? 1 : 0) }
  end

  def self.part2
  end

  def self.load_passwords
    File.read('../inputs/day02-input.txt').split("\n")
  end
end

class PasswordEntry
  attr_accessor :policy, :value
  def initialize(entry)
    policy, value = entry.split(": ")
    @policy = Policy.new(policy)
    @value = value
  end

  def valid?
    occurances = value.count(policy.char)
    occurances >= policy.min && occurances <= policy.max
  end
end

class Policy
  attr_accessor :min, :max, :char
  def initialize(policy)
    min, max, @char = policy.split(/[-\s]/)
    @min = min.to_i
    @max = max.to_i
  end
end
