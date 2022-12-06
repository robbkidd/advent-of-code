class Day06
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  def part1
    start_of_packet_marker(@input)
  end

  def part2
  end

  # @example
  #   day.start_of_packet_marker('mjqjpqmgbljsphdztnvjfqwrcgsmlb') => 7
  #   
  # @example
  #   day.start_of_packet_marker('bvwbjplbgvbhsrlpgdmjqwftvncz') => 5
  #   
  # @example
  #   day.start_of_packet_marker('nppdvjthqldpwncqszvftbrmjlhg') => 6
  #   
  # @example
  #   day.start_of_packet_marker('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg') => 10
  #   
  # @example
  #   day.start_of_packet_marker('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw') => 11
  #   
  def start_of_packet_marker(buffer)
    chars = buffer.tr("\n","").chars
    scan = 3
    found = false
    while !found || scan < chars.length do
      check = chars[scan-3..scan]
      if check.uniq.length == 4
         found = true
         break
      end
      scan += 1
    end
    return scan + 1
  end

  def real_input
    File.read('../inputs/day06-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
  INPUT
end
