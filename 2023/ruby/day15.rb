require_relative 'day'

class Day15 < Day # >

  # @example
  #   day.part1 #=> 1320
  def part1
    initialization_sequence
      .reduce(0) { |sum, step| sum += HASH.hash(step) }
  end

  # example
  #   day.part2 #=> 'how are you'
  def part2
  end

  # @example parses_input
  #   h = new(Day15::EXAMPLE_INPUT)
  #   h.initialization_sequence #=> %w{rn=1 cm- qp=3 cm=2 qp- pc=4 ot=9 ab=5 pc- pc=6 ot=7}
  def initialization_sequence
    @initialization_sequence ||=
      input.tr("\n", "").split(",")
  end

  EXAMPLE_INPUT = <<~INPUT
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
  INPUT
end

#class Holiday_ASCII_String_Helper
module HASH
  # @example
  #   HASH.hash("") #=> 0
  # @example HASH
  #   HASH.hash("HASH") #=> 52
  # @example from_example_input
  #   HASH.hash("rn=1") #=> 30
  #   HASH.hash("cm-") #=> 253
  #   HASH.hash("qp=3") #=> 97
  #   HASH.hash("cm=2") #=> 47
  #   HASH.hash("qp-") #=> 14
  #   HASH.hash("pc=4") #=> 180
  #   HASH.hash("ot=9") #=> 9
  #   HASH.hash("ab=5") #=> 197
  #   HASH.hash("pc-") #=> 48
  #   HASH.hash("pc=6") #=> 214
  #   HASH.hash("ot=7") #=> 231
  def self.hash(str="")
    str
      .each_byte             # Determine the ASCII code for the current character of the string.
      .inject(0) do |current_value, ord| # start with a current value of 0
        current_value += ord # Increase the current value by the ASCII code you just determined.
        current_value *= 17  # Set the current value to itself multiplied by 17.
        current_value %= 256 # Set the current value to the remainder of dividing itself by 256.
      end
  end
end
