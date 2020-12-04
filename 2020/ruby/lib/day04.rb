class Day04
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    Passport.scanner(load_passports).map(&:valid?).count(true)
  end

  def self.part2
  end

  def self.load_passports
    File.read('../inputs/day04-input.txt').split("\n")
  end
end

class Passport
  REQUIRED_FIELDS = %w{ byr iyr eyr hgt hcl ecl pid cid }
  OUR_HACK = REQUIRED_FIELDS - %w{ cid }

  def self.scanner(feed)
    feed.chunk_while {|line| line != ""}
        .map { |segments| segments.join(" ").chomp }
        .map { |data| new data }
  end

  def initialize(data = "")
    @data = parse data
  end

  def parse(data)
    data.split(" ")
        .each_with_object(Hash.new) do |field, passport| 
          key, value = field.split(":")
          passport[key] = value
        end
  end

  def valid?
    return false unless all_required_fields_present?
    true
  end
  
  def all_required_fields_present?
    (OUR_HACK & @data.keys).size == OUR_HACK.size
  end
end
