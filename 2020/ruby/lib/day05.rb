class Day05
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    load_boarding_passes.map { |p| BoardingPass.new(p).seat_id }
                        .max
  end

  def self.part2
  end

  def self.load_boarding_passes
    File.read('../inputs/day05-input.txt').split("\n")
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
