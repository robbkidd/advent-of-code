class Day3

  def self.part1
    wires = File.read('day03-input.txt').split("\n")
    Panel.closest_distance(wires[0], wires[1])
  end

  def self.part2
    wires = File.read('day03-input.txt').split("\n")
    Panel.fewest_steps(wires[0], wires[1])
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

require 'rspec'

describe 'part1' do
  it 'example one' do
    wire1_path = "R8,U5,L5,D3"
    wire2_path = "U7,R6,D4,L4"
    expect(Panel.closest_distance(wire1_path, wire2_path)).to eq(6)
  end

  it 'example two' do
    wire1_path = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    wire2_path = "U62,R66,U55,R34,D71,R55,D58,R83"
    expect(Panel.closest_distance(wire1_path, wire2_path)).to eq(159)
  end

  it 'example three' do
    wire1_path = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    wire2_path = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    expect(Panel.closest_distance(wire1_path, wire2_path)).to eq(135)
  end
end

describe 'part2' do
  it 'example one' do
    wire1_path = "R8,U5,L5,D3"
    wire2_path = "U7,R6,D4,L4"
    expect(Panel.fewest_steps(wire1_path, wire2_path)).to eq(30)
  end

  it 'example two' do
    wire1_path = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    wire2_path = "U62,R66,U55,R34,D71,R55,D58,R83"
    expect(Panel.fewest_steps(wire1_path, wire2_path)).to eq(610)
  end

  it 'example three' do
    wire1_path = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    wire2_path = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    expect(Panel.fewest_steps(wire1_path, wire2_path)).to eq(410)
  end
end

describe Location do
  context 'tracing' do
    it 'goes right' do
      expect(subject.go_right(3).map(&:to_a)).to eq([[1,0],[2,0],[3,0]])
    end
    it 'goes left' do
      expect(subject.go_left(3).map(&:to_a)).to eq([[-1,0],[-2,0],[-3,0]])
    end
    it 'goes up' do
      expect(subject.go_up(3).map(&:to_a)).to eq([[0, 1], [0, 2], [0, 3]])
    end
    it 'goes down' do
      expect(subject.go_down(3).map(&:to_a)).to eq([[0, -1], [0, -2], [0, -3]])
    end
  end
end

describe Panel do
  context 'path tracing' do
    it 'goes right' do
      expect(Panel.trace_path("R3").map(&:to_a)).to eq([[0,0],[1,0],[2,0],[3,0]])
    end
    it 'goes left' do
      expect(Panel.trace_path("L3").map(&:to_a)).to eq([[0,0],[-1,0],[-2,0],[-3,0]])
    end
    it 'goes up' do
      expect(Panel.trace_path("U3").map(&:to_a)).to eq([[0,0],[0,1],[0,2],[0,3]])
    end
    it 'goes down' do
      expect(Panel.trace_path("D3").map(&:to_a)).to eq([[0,0],[0,-1],[0,-2],[0,-3]])
    end
  end
end
