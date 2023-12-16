require_relative 'day'

class Day15 < Day # >

  # @example
  #   day.part1 #=> 1320
  def part1
    initialization_sequence
      .reduce(0) { |sum, step| sum += hash(step) }
  end

  # @example
  #   day.part2 #=> 145
  def part2
    # "... a series of 256 boxes numbered 0 through 255 ..."
    boxes = Array.new(256) { Hash.new }

    # "... perform each step in the initialization sequence ..."
    initialization_sequence
      .each do |step|
        label, op, focal_length = /\A(.*)([-,\=])(.*)?\z/.match(step)[1..3]
        case op
        when "-" ; boxes[hash(label)].delete(label)
        when "=" ; boxes[hash(label)].store(label, focal_length.to_i)
        else     ; raise("lolwut")
        end
      end

    # "To confirm that all of the lenses are installed correctly,
    #  add up the focusing power of all of the lenses."
    boxes
      .map.with_index { |box, box_number| # box numbers are 0-255
        box
          .values # only need the focal lengths not the labels
          .map.with_index(1) { |focal_length, slot_number| # box slot numbers start at 1
            # "The focusing power of a single lens is the result of multiplying together:
            # " - One plus the box number of the lens in question.
            # " - The slot number of the lens within the box: 1 for the first lens, ...
            # " - The focal length of the lens."
            (box_number + 1) * slot_number * focal_length
          }
      }
      .flatten
      .reduce(&:+)
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

  # @example default_start
  #   new.hash("") #=> 0
  # @example HASH
  #   new.hash("HASH") #=> 52
  # @example from_example_input
  #   new.hash("rn=1") #=> 30
  #   new.hash("cm-") #=> 253
  #   new.hash("qp=3") #=> 97
  #   new.hash("cm=2") #=> 47
  #   new.hash("qp-") #=> 14
  #   new.hash("pc=4") #=> 180
  #   new.hash("ot=9") #=> 9
  #   new.hash("ab=5") #=> 197
  #   new.hash("pc-") #=> 48
  #   new.hash("pc=6") #=> 214
  #   new.hash("ot=7") #=> 231
  def hash(str="")
    str                      # "... for each character in the string starting from the beginning:"
      .each_byte             # "Determine the ASCII code for the current character of the string."
      .inject(0) do |current_value, ord| # "... start with a current value of 0."
        current_value += ord # "Increase the current value by the ASCII code you just determined."
        current_value *= 17  # "Set the current value to itself multiplied by 17."
        current_value %= 256 # "Set the current value to the remainder of dividing itself by 256."
      end
  end
end
