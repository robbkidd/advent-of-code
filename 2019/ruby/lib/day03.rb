class Day03
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    Panel.closest_distance(wires[0], wires[1])
  end

  def self.part2
    Panel.fewest_steps(wires[0], wires[1])
  end

  def self.wires
    File.read('../inputs/day03-input.txt').split("\n")
  end
end

class Panel
  def self.closest_distance(wire1_path, wire2_path)
    crossovers = trace_path(wire1_path) & trace_path(wire2_path)
    central_port = crossovers.shift
    crossovers.map do |xover|
      xover.manhattan_distance(central_port)
    end.sort.first
  end

  def self.fewest_steps(wire1_path, wire2_path)
    wire1_trace = trace_path(wire1_path)
    wire2_trace = trace_path(wire2_path)
    crossovers = wire1_trace & wire2_trace
    _central_port = crossovers.shift
    crossovers.map do |xover|
      wire1_trace.find_index {|step| step.eql? xover} + wire2_trace.find_index {|step| step.eql? xover}
    end.sort.first
  end

  def self.trace_path(path)
    steps = path.split(",")
    steps.each_with_object([Location.new]) do |step, wire_path|
      direction, distance = step[0], step[1..].to_i
      current_location = wire_path.last
      case direction
      when "R"
        wire_path.concat(current_location.go_right(distance))
      when "L"
        wire_path.concat(current_location.go_left(distance))
      when "U"
        wire_path.concat(current_location.go_up(distance))
      when "D"
        wire_path.concat(current_location.go_down(distance))
      end
    end
  end
end

class Location
  attr_reader :x, :y
  def initialize(x: 0, y: 0)
    @x = x
    @y = y
  end

  def manhattan_distance(other)
    (self.x - other.x).abs + (self.y - other.y).abs
  end

  def eql?(other)
    self.x == other.x && self.y == other.y
  end

  def hash
    [self.x, self.y].hash
  end

  def to_a
    [x,y]
  end

  def go_right(distance)
    (self.x+1).upto(self.x + distance).each_with_object([]) do |step, path|
      path << Location.new(x: step, y: self.y)
    end
  end

  def go_left(distance)
    (self.x-1).downto(self.x - distance).each_with_object([]) do |step, path|
      path << Location.new(x: step, y: self.y)
    end
  end

  def go_up(distance)
    (self.y+1).upto(self.y + distance).each_with_object([]) do |step, path|
      path << Location.new(x: self.x, y: step)
    end
  end

  def go_down(distance)
    (self.y-1).downto(self.y - distance).each_with_object([]) do |step, path|
      path << Location.new(x: self.x, y: step)
    end
  end
end
