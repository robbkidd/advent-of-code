class Day06
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = (input || real_input).strip
  end

  def part1
    start_of_packet_marker(@input)
  end

  def part2
    start_of_message_marker(@input)
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
    scan_for_length(buffer, 4)
  end

  # @example
  #   day.start_of_message_marker('mjqjpqmgbljsphdztnvjfqwrcgsmlb') => 19
  #   
  # @example
  #   day.start_of_message_marker('bvwbjplbgvbhsrlpgdmjqwftvncz') => 23
  #   
  # @example
  #   day.start_of_message_marker('nppdvjthqldpwncqszvftbrmjlhg') => 23
  #   
  # @example
  #   day.start_of_message_marker('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg') => 29
  #   
  # @example
  #   day.start_of_message_marker('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw') => 26
  #   
  def start_of_message_marker(buffer)
    scan_for_length(buffer, 14)
  end
  
  def scan_for_length(buffer, packet_length)
    chars = buffer.chars
    scan = lookback = packet_length - 1
    while scan < chars.length do
      break if packet_length == chars[scan-lookback..scan].uniq.length
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
