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
    @policy = OldJobPolicy.new(policy)
    @value = value
  end

  def valid?
    policy.valid_password? value
  end
end

class OfficialTobogganCorporatePolicy
  attr_accessor :first_position, :second_position, :char
  def initialize(policy)
    first_position, second_position, @char = policy.split(/[-\s]/)
    @first_position = first_position.to_i
    @second_position = second_position.to_i
  end

  def valid_password?(password)
    (password[first_position-1] == char) ^ (password[second_position-1] == char)
  end
end

class OldJobPolicy
  attr_accessor :min, :max, :char
  def initialize(policy)
    min, max, @char = policy.split(/[-\s]/)
    @min = min.to_i
    @max = max.to_i
  end

  def valid_password?(password)
    occurances = password.count(char)
    occurances >= min && occurances <= max
  end
end
