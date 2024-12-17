require_relative 'day'
require_relative 'grid'
require 'set'

class Day06 < Day # >
  attr_accessor :guard

  # @example
  #   day.part1 #=> 41
  def part1
    @start = nil
    @lab_map =
      Grid
        .new(input)
        .parse do |coord, char|
          @start = coord if char == '^'
        end

    predict_path(@lab_map, @start)
      .count
  end

  # @example
  #   day.part1
  #   day.part2 #=> 6
  def part2
    predict_path(@lab_map, @start)
      .map { |location|
        predict_path(@lab_map, @start, new_obstruction: location)
      }
      .map(&:first)
      .count
  end

  def predict_path(map, start, new_obstruction: nil)
    guard = Guard.new(start, '^')

    map.set(new_obstruction, 'O') if new_obstruction
    loop do
      case map.at(guard.next_step)
      when '.','^' ; guard.step_forward!
      when '#','O' ; guard.turn_right!
      when :out_of_bounds
        break
      end
    end

    guard.visited
  # rescue LoopDetected
  #   return :loop_detected
  ensure
    map.set(new_obstruction, '.') if new_obstruction
  end

  EXAMPLE_INPUT = File.read("../inputs/day06-example-input.txt")

  class Guard
    attr_accessor :position, :facing
    attr_reader :visited

    DIRECTIONS = {
      '^' => 0,
      '>' => 90,
      'v' => 180,
      '<' => 270,
    }

    def initialize(position, facing)
      @position = position
      @facing = DIRECTIONS.fetch(facing)
      @visited = Set.new.add([@position, @facing])
    end

    def next_step
      case facing
      when   0 ; [ position[0] -1, position[1]    ]
      when  90 ; [ position[0]   , position[1] +1 ]
      when 180 ; [ position[0] +1, position[1]    ]
      when 270 ; [ position[0]   , position[1] -1 ]
      else
        raise "lolwut: weird facing direction #{facing}"
      end
    end

    class LoopDetected < RuntimeError; end

    def step_forward!
      @position = next_step
      @visited.add?([@position, @facing]) or raise LoopDetected
    end

    def turn_right!
      @facing = (facing + 90).modulo(360)
    end
  end
end

require 'rspec'

describe 'Day06' do
  let(:day) { Day06.new(Day06::EXAMPLE_INPUT) }
  it 'answers part 1' do
    expect(day.part1).to eq(41)
  end

  it 'answers part 2' do
    day.part1 # part 2 depends on state determined from part 1
    # expect(day.part2).to eq(6)
    expect(day.part2).to eq([[6,3], [7,6], [7,8], [8,1], [8,3], [9,7]])
  end

  describe 'Guard' do
    subject { Day06::Guard.new([4,5], '^') }

    it "knows their next step" do
      expect(subject.next_step).to eq([3,5])
    end

    it "can step forward" do
      subject.step_forward!
      expect(subject.position).to eq([3,5])
    end

    it "can turn right" do
      subject.turn_right!
      expect(subject.facing).to eq(90)

      subject.turn_right!
      subject.turn_right!
      expect(subject.facing).to eq(270)
    end
  end
end
