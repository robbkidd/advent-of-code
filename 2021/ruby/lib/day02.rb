class Day02
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def part1
    submarine = Sub.new
    submarine.follow_instructions(planned_course)
    submarine.where_you_at
  end

  def part2
    submarine = SlightlyMoreComplicatedSub.new
    submarine.follow_instructions(planned_course)
    submarine.where_you_at
  end

  def planned_course
    File.read('../inputs/day02-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
  INPUT
end

class Sub
  attr_reader :depth, :horiz_pos

  class NegativeDepthError < RuntimeError
    def message; "lolwut: Are you floating?"; end
  end

  def initialize(depth: 0, horiz_pos: 0)
    @depth = depth
    @horiz_pos = horiz_pos
  end

  def where_you_at
    @horiz_pos * @depth
  end

  def follow_instructions(course)
    course
      .split("\n")
      .map { |step|
        command, units = step.split(" ")
        [ command.to_sym, units.to_i ]
      }
      .each do |command, units|
        self.send(command, units)
      end
  end

  def forward(units)
    @horiz_pos = horiz_pos + units
  end

  def down(units)
    @depth = depth + units
  end

  def up(units)
    @depth = depth - units
    raise NegativeDepthError if @depth < 0
  end
end

class SlightlyMoreComplicatedSub < Sub
  attr_reader :aim

  def initialize(depth: 0, horiz_pos: 0)
    super(depth: depth, horiz_pos: horiz_pos)
    @aim = 0
  end

  def forward(units)
    super(units)
    @depth = depth + (aim * units)
    raise NegativeDepthError if @depth < 0
  end

  def down(units)
    @aim = aim + units
  end

  def up(units)
    @aim = aim - units
  end
end
