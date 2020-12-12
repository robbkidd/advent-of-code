class Day12
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    ship = Ship.new
    ship.follow_instructions
    ship.distance_from_start
  end

  def part2
    ship = ShipWithWaypoint.new
    ship.follow_instructions
    ship.distance_from_start
  end

  def self.example_input
    <<~EXAMPLE
      F10
      N3
      F7
      R90
      F11
    EXAMPLE
  end
end

class Ship
  COMPASS = ["E", "S", "W", "N"]

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day12-input.txt"))
               .split("\n")
               .map{|line| [ line[0], line[1..].to_i ] }
    @facing = "E"
    @starting_point = {x: 0, y: 0}
    @current_coords = {x: 0, y: 0}
  end

  def follow_instructions
    @input.each do |action, value|
      actions[action].call(value)
    end
  end

  def actions
    @actions ||= {
      "N" => -> (value) { @current_coords[:y] += value },
      "S" => -> (value) { @current_coords[:y] -= value },
      "E" => -> (value) { @current_coords[:x] += value },
      "W" => -> (value) { @current_coords[:x] -= value },
      "L" => -> (value) { @facing = COMPASS[(COMPASS.index(@facing) - (value / 90) ) % 4] }, 
      "R" => -> (value) { @facing = COMPASS[(COMPASS.index(@facing) + (value / 90) ) % 4] }, 
      "F" => -> (value) { actions[@facing].call(value) },
    }
  end

  def distance_from_start
    (@starting_point[:x] - @current_coords[:x]).abs + (@starting_point[:y] - @current_coords[:y]).abs
  end
end

class ShipWithWaypoint < Ship
  def initialize(input = nil)
    super
    @waypoint = {x: 10, y: 1}
  end

  def actions
    @actions ||= {
      "N" => -> (value) { @waypoint[:y] += value },
      "S" => -> (value) { @waypoint[:y] -= value },
      "E" => -> (value) { @waypoint[:x] += value },
      "W" => -> (value) { @waypoint[:x] -= value },
      "L" => -> (value) { (value / 90).times {
                            @waypoint[:x], @waypoint[:y] = -@waypoint[:y], @waypoint[:x]
                          }
                        }, 
      "R" => -> (value) { (value / 90).times { 
                            @waypoint[:x], @waypoint[:y] = @waypoint[:y], -@waypoint[:x]
                          } 
                        }, 
      "F" => -> (value) { @current_coords[:x] += @waypoint[:x] * value
                          @current_coords[:y] += @waypoint[:y] * value }
    }
  end
end
