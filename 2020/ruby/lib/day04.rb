class Day04
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    Passport.scanner(load_passports)
            .map(&:all_required_fields_present?)
            .count(true)
  end

  def self.part2
    Passport.scanner(load_passports)
            .map(&:valid?)
            .count(true)
  end

  def self.load_passports
    File.read('../inputs/day04-input.txt').split("\n")
  end
end

class Passport

  FIELD_RULES = {
    # "cid" is not required in our hack
    "byr" => -> (birth_year) { 1920 <= birth_year.to_i && birth_year.to_i <= 2002 },
    "iyr" => -> (issue_year) { 2010 <= issue_year.to_i && issue_year.to_i <= 2020 },
    "eyr" => -> (exp_year)   { 2020 <= exp_year.to_i && exp_year.to_i <= 2030 },
    "hcl" => -> (hair_color) { /#(\d|[a-f]){6}/.match? hair_color }, 
    "pid" => -> (passport_id) { /\A\d{9}\z/.match? passport_id },
    "ecl" => -> (eye_color)  { %w{amb blu brn gry grn hzl oth}.include? eye_color },
    "hgt" => -> (height) do 
      case height
      when /(\d+)cm/
        150 <= $1.to_i && $1.to_i <= 193 
      when /(\d+)in/
        59 <= $1.to_i && $1.to_i <= 76
      else
        false
      end
    end,
  }
  REQUIRED_FIELDS = FIELD_RULES.keys

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
    FIELD_RULES.map { |field, rule| rule.call(@data[field]) }
               .all? true
  end
  
  def all_required_fields_present?
    (REQUIRED_FIELDS & @data.keys).size == REQUIRED_FIELDS.size
  end
end
