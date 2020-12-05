class Day05
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    boarding_pass_seat_ids.max
  end

  def self.part2
    seat_ids = boarding_pass_seat_ids.sort
    ((seat_ids[0]..seat_ids[-1]).to_a - seat_ids).first
  end

  def self.boarding_pass_seat_ids
    File.read('../inputs/day05-input.txt')
        .split("\n")
        .map { |code| BoardingPass.new(code).seat_id }
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
