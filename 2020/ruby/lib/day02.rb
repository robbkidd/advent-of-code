class Day02
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    passwords = load_passwords.map { |p| PasswordEntry.new(p, OldJobPolicy) }
    passwords.inject(0) { |valid_count, p| valid_count += (p.valid? ? 1 : 0) }
  end

  def self.part2
    passwords = load_passwords.map { |p| PasswordEntry.new(p, OfficialTobogganCorporatePolicy) }
    passwords.inject(0) { |valid_count, p| valid_count += (p.valid? ? 1 : 0) }
  end

  def self.load_passwords
    File.read('../inputs/day02-input.txt').split("\n")
  end
end

class PasswordEntry
  attr_accessor :policy, :value
  def initialize(entry, policy_engine = OldJobPolicy)
    policy, value = entry.split(": ")
    @policy = policy_engine.new(policy)
    @value = value
  end

  def valid?
    policy.valid_password? value
  end
end

class OfficialTobogganCorporatePolicy
  attr_accessor :first_index, :second_index, :char
  def initialize(policy)
    first_position, second_position, @char = policy.split(/[-\s]/)
    # account for Toboggan Corporate Policies having no concept of "index zero" 
    @first_index = first_position.to_i - 1
    @second_index = second_position.to_i - 1
  end

  def valid_password?(password)
    (password[first_index] == char) ^ (password[second_index] == char)
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
    occurrences = password.count(char)
    min <= occurrences && occurrences <= max
  end
end
