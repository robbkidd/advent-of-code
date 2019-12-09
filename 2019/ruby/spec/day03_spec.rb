require 'rspec'
require_relative '../lib/day03.rb'

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
