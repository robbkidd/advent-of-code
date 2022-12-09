require_relative 'day'
require 'set'

class Day09 < Day # >

  # @example
  #   day.part1 #=> 13
  def part1
    Rope
      .new
      .go_through_the_motions(motions)
      .tail_visits
      .count
  end

  # @example
  #   day.part2 #=> 1
  # @example larger input
  #   day = Day09.new(Day09::PART2_EXAMPLE_INPUT)
  #   day.part2 #=> 36
  def part2
    Rope
      .new(10)
      .go_through_the_motions(motions)
      .tail_visits
      .count
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

  PART2_EXAMPLE_INPUT = <<~PART2
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
  PART2
end

class Rope
  START = [0,0]

  attr_reader :knots, :length, :tail_visits
  
  # @example part1 length
  #   rope = Rope.new
  #   rope.head #=> [0,0]
  #   rope.tail #=> [0,0]
  #   rope.knots #=> [[0, 0], [0, 0]]
  #
  # @example part2 length
  #   rope = Rope.new(10)
  #   rope.knots.length #=> 10
  #   rope.knots        #=> [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
  #   rope.head         #=> [0,0]
  #   rope.tail         #=> [0,0]
  def initialize(length=2)
    @length = length
    @knots = Array.new(length, START)
    @tail_visits = Set.new.add(tail)
  end

  def head
    knots.first
  end

  def tail
    knots.last
  end

  def go_through_the_motions(motions)
    motions
      .each do |direction, steps| 
        steps.times { step(direction) }
      end

    self
  end

  # @example simple step
  #   rope = Rope.new
  #   rope.head      #=> [0,0]
  #   rope.to_s      #=> EXAMPLE_STATES["initial"].strip
  #
  # @example first motion, one step
  #   rope = Rope.new
  #   rope.head      #=> [0,0]
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
    next_knots = []
    next_knots << move_knot(head, DIR_OFFSET.fetch(direction))

    (1..length-1)
      .each do |idx|
        knot = knots.at(idx)
        knot_ahead = next_knots.at(idx-1)

        if plancky?(knot_ahead, knot)
          next_knots << knot
        else
          next_knots << move_knot(knot, offset_toward(knot_ahead, knot))
        end
      end
    
    raise :whaaat unless next_knots.length == @knots.length

    @knots = next_knots
    tail_visits.add(tail)
  end

  def move_knot(knot_pos, offset)
    [
      knot_pos[0] + offset[0],
      knot_pos[1] + offset[1],
    ]
  end

  def offset_toward(ahead, behind)
    [
      ahead[0] <=> behind[0],
      ahead[1] <=> behind[1],
    ]
  end

  # @example
  #   rope = Rope.new
  #   rope.plancky?( [0,0], [0,0]) #=> true
  #   rope.plancky?( [0,1], [0,0]) #=> true
  def plancky?(ahead, behind)
    difference(ahead, behind)
      .map(&:abs)
      .all? {|d| -2 < d && d < 2}
  end

  def difference(a, b)
    [a,b]
      .transpose
      .map { |d1,d2| d1 - d2 }
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