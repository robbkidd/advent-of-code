require 'set'

class Day17
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}"
    puts "Part2: #{day.part2}"
  end

  def part1
    cubes = ConwayCubes.new
    6.times { cubes.tick }
    cubes.currently_active.count
  end

  def part2
  end

  def self.example_input
    <<~EXAMPLE
      .#.
      ..#
      ###
    EXAMPLE
  end
end

class ConwayCubes
  attr_accessor :currently_active, :states

  CUBE_OFFSETS = [-1, -1, -1, 0, 0, 1, 1, 1].permutation(3).to_a.uniq.freeze

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day17-input.txt"))
    @currently_active = start_state
    @states = [] << @currently_active
  end

  def start_state
    start_cubes = Set.new
    @input.split("\n")
          .map { |row| row.chars }
          .each_with_index do |row, y|
            row.each_with_index do |cube, x|
              start_cubes << [0,y,x] if cube == "#"
            end
          end
    start_cubes
  end

  def tick
    @currently_active = next_state
    @states << @currently_active
  end

  def next_state
    new_cubes = Set.new
    currently_active.map{ |cube| neighbors_for(cube) }
                    .flatten(1)
                    .uniq
                    .each do |cube|
                      if currently_active.include?(cube)
                        new_cubes << cube if (2..3).cover?(neighbors_active_for(cube).count)
                      else
                        new_cubes << cube if neighbors_active_for(cube).count == 3
                      end
                    end
    new_cubes
  end

  def neighbors_for(location)
    neighbor_coords = CUBE_OFFSETS.map{ |offset|
      location.zip(offset)
              .map { |p| p.reduce(&:+) }
    }
  end

  def neighbors_active_for(location)
    neighbors_for(location).select { |neighbor_coords| currently_active.include?(neighbor_coords) }
  end
end
