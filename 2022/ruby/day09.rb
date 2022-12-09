require_relative 'day'
require 'set'

class Day09 < Day # >

  # @example
  #   day.part1 #=> 13
  def part1
    rope = Rope.new
    motions
      .each do |direction, steps| 
        steps.times { rope.step(direction) }
      end

    rope.tail_visits.count
  end

  # @example
  #   day.part2
  def part2
  end

  # @example
  #   day.motions #=> [["R", 4], ["U", 4], ["L", 3], ["D", 1], ["R", 4], ["D", 1], ["L", 5], ["R", 2]] 
  def motions
    @motions ||=
      input
        .split("\n")
        .map{ |line| line.split(" ") }
        .map{ |direction, steps| [direction, steps.to_i] }
  end

  EXAMPLE_INPUT = <<~INPUT
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
  INPUT
end

# @example
#   rope = Rope.new
#   rope.head #=> [0,0]
class Rope
  START = [0,0]

  attr_reader :head, :tail, :tail_visits

  def initialize
    @head = @tail = START
    @tail_visits = Set.new.add(@tail)
  end

  # @example simple step
  #   rope = Rope.new
  #   rope.head      #=> [0,0]
  #   rope.to_s      #=> EXAMPLE_STATES["initial"].strip
  #
  # @example first motion, one step
  #   rope = Rope.new
  #   rope.step("R")
  #   rope.to_s      #=> EXAMPLE_STATES["1-R 4.1"].strip
  #
  # @example first motion, two step
  #   rope = Rope.new
  #   rope.step("R")
  #   rope.to_s      #=> EXAMPLE_STATES["1-R 4.1"].strip
  #   rope.step("R")
  #   rope.to_s      #=> EXAMPLE_STATES["1-R 4.2"].strip
  #
  # @example first motion, whole
  #   rope = Rope.new
  #   4.times { rope.step("R") }
  #   rope.to_s      #=> EXAMPLE_STATES["1-R 4.4"].strip
  def step(direction)
    @head = @head.zip(DIR_OFFSET.fetch(direction)).map {|p| p.reduce(&:+)}
    if !plancky?
      tail_should_move = @head.zip(@tail).map {|p| p.reduce(&:<=>)}
      @tail = @tail
                .zip( @head.zip(@tail).map {|p| p.reduce(&:<=>)} ) # < / = / > ?
                .map {|p| p.reduce(&:+)}
      
      @tail_visits.add(@tail)
    end
  end

  def plancky?
    look_around_you(@tail).include?(@head)
  end

  TOUCHING_OFFSETS = [-1, -1, 0, 0, 1, 1].permutation(2).to_a.uniq.freeze
  # @example includes the given location
  #   rope = Rope.new
  #   rope.look_around_you([0,0]).length          #=> 9
  #   rope.look_around_you([0,0]).include?([0,0]) #=> true
  #
  # @example works for more than origin
  #   rope = Rope.new
  #   rope.look_around_you([10,20]) #=> [[9, 19], [9, 20], [9, 21], [10, 19], [10, 20], [10, 21], [11, 19], [11, 20], [11, 21]]
  def look_around_you(location)
    TOUCHING_OFFSETS.map{ |offset|
      location
        .zip(offset)
        .map { |p| p.reduce(&:+) }
    }
  end

  # map an input direction to a grid offset
  #
  # offset is [row, column], not [x, y]
  DIR_OFFSET = {
    "R" => [  0,  1 ],
    "L" => [  0, -1 ],
    "U" => [  1,  0 ],
    "D" => [ -1,  0 ],
  }

  def to_s
    (0..4).map { |row|
      (0..5).map { |column|
        case [row, column]
        when head  ; "H"
        when tail  ; "T"
        when [0,0] ; "s"
        else       ; "."
        end
      }.join("") # squash the columns into a single string
    }.reverse.join("\n") # lines of rows go upwards for display
  end
end

EXAMPLE_STATES = {
  #== Initial State ==
  # (H covers T, s)
  "initial" => <<~STATE,
    ......
    ......
    ......
    ......
    H..... 
  STATE

  #== R 4 ==

  #  (T covers s)
  "1-R 4.1" => <<~STATE,
    ......
    ......
    ......
    ......
    TH....
  STATE

  "1-R 4.2" => <<~STATE,
    ......
    ......
    ......
    ......
    sTH...
  STATE

  "1-R 4.3" => <<~STATE,
    ......
    ......
    ......
    ......
    s.TH..
  STATE

  "1-R 4.4" => <<~STATE,
    ......
    ......
    ......
    ......
    s..TH.
  STATE

  #  == U 4 ==

  "2-U 4.1" => <<~STATE,
    ......
    ......
    ......
    ....H.
    s..T..
  STATE

  "2-U 4.2" => <<~STATE,
    ......
    ......
    ....H.
    ....T.
    s.....
  STATE

  "2-U 4.3" => <<~STATE,
    ......
    ....H.
    ....T.
    ......
    s.....
  STATE

  "2-U 4.4" => <<~STATE,
    ....H.
    ....T.
    ......
    ......
    s.....
  STATE

  #  == L 3 ==

  "3-L 3.1" => <<~STATE,
    ...H..
    ....T.
    ......
    ......
    s.....
  STATE

  "3-L 3.2" => <<~STATE,
    ..HT..
    ......
    ......
    ......
    s.....
  STATE

  "3-L 3.3" => <<~STATE,
    .HT...
    ......
    ......
    ......
    s.....
  STATE

  #  == D 1 ==

  "4-D 1.1" => <<~STATE,
    ..T...
    .H....
    ......
    ......
    s.....
  STATE

  #  == R 4 ==

  "5-R 4.1" => <<~STATE,
    ..T...
    ..H...
    ......
    ......
    s.....
  STATE

  "5-R 4.2" => <<~STATE,
    ..T...
    ...H..
    ......
    ......
    s.....
  STATE

  "5-R 4.3" => <<~STATE,
    ......
    ...TH.
    ......
    ......
    s.....
  STATE

  "5-R 4.4" => <<~STATE,
    ......
    ....TH
    ......
    ......
    s.....
  STATE

  #  == D 1 ==

  "6-D 1.1" => <<~STATE,
    ......
    ....T.
    .....H
    ......
    s.....
  STATE

  #  == L 5 ==

  "7-L 5.1" => <<~STATE,
    ......
    ....T.
    ....H.
    ......
    s.....
  STATE

  "7-L 5.2" => <<~STATE,
    ......
    ....T.
    ...H..
    ......
    s.....
  STATE
 
  "7-L 5.3" => <<~STATE,
    ......
    ......
    ..HT..
    ......
    s.....
  STATE

  "7-L 5.4" => <<~STATE,
    ......
    ......
    .HT...
    ......
    s.....
  STATE

  "7-L 5.5" => <<~STATE,
    ......
    ......
    HT....
    ......
    s.....
  STATE

  #  == R 2 ==

  #  (H covers T)
  "8-R 2.1" => <<~STATE,
    ......
    ......
    .H....
    ......
    s.....
  STATE
 
  "8-R 2.2" => <<~STATE,
    ......
    ......
    .TH...
    ......
    s.....
  STATE
}