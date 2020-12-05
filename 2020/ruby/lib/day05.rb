class Day05
  def self.go
    day = new
    puts "Part1: #{day.part1}"
    puts "Part2: #{day.part2}"
    puts ""
    puts "ಠ_ಠ"
    puts
    puts "Or with _only_ binary shenanigans"
    puts day.ಠ_ಠ
  end

  def initialize
    @input = File.read("../inputs/#{self.class.name.downcase}-input.txt")
                 .split("\n")
  end

  def part1
    boarding_pass_seat_ids.max
  end

  def part2
    seat_ids = boarding_pass_seat_ids.sort
    ((seat_ids[0]..seat_ids[-1]).to_a - seat_ids).first
  end

  def boarding_pass_seat_ids
    @input.map { |code| BoardingPass.new(code).seat_id }
  end

  def ಠ_ಠ
    # OK, the whole thing can be done with just binary mathy math
    # the row is already x8 because of its digits placement
    seat_ids = @input.map { |code| code.tr("FL", "0").tr("BR", "1").to_i(2) }
                     .sort
    
    [seat_ids[-1], ((seat_ids[0]..seat_ids[-1]).to_a - seat_ids).first]
  end
end

class BoardingPass
  def initialize(passcode)
    @passcode = passcode
  end

  def seat_id
    row * 8 + col
  end

  def row
    @row ||= in_binary[0..6].to_i(2)
  end

  def col
    @col ||= in_binary[7..-1].to_i(2)
  end

  def in_binary
    @in_binary ||= @passcode.tr("FL", "0").tr("BR", "1")
  end
end
