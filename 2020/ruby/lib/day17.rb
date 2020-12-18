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
    cubes = ConwayHypercubes.new
    6.times { cubes.tick }
    cubes.currently_active.count
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

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day17-input.txt"))
    @currently_active = start_state
    @states = [] << @currently_active
  end

  def dimensions
    3
  end

  def offsets
    @offsets ||= ( ([-1, 1] * dimensions) +
                   ([0] * (dimensions-1)) # omit reference to self
                 ).permutation(dimensions).to_a.uniq.freeze
  end

  def extra_dimensions
    [0] * (dimensions-2)
  end

  def start_state
    start_cubes = Set.new
    @input.split("\n")
          .map { |row| row.chars }
          .each_with_index do |row, y|
            row.each_with_index do |cube, x|
              start_cubes << extra_dimensions+[y,x] if cube == "#"
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
    neighbor_coords = offsets.map{ |offset|
      location.zip(offset)
              .map { |p| p.reduce(&:+) }
    }
  end

  def neighbors_active_for(location)
    neighbors_for(location).select { |neighbor_coords| currently_active.include?(neighbor_coords) }
  end
end

class ConwayHypercubes < ConwayCubes
  def dimensions
    4
  end
end
