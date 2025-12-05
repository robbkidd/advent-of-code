require_relative 'day'
require_relative 'grid'

class Day04 < Day # >
  attr_accessor :diagram

  def initialize(input=nil)
    super
    @diagram = Diagram.new(input())
  end

  # @example
  #   day.part1 #=> 13
  def part1
    accessible = []

    diagram
      .each {|coords, contents|
        accessible << coords if contents == "@" && diagram.accessible?(coords)
      }

    accessible.count
  end

  # @example
  #   day.part2 #=> 43
  def part2
    removed = []
    rolls = diagram.dup

    loop do
      remove_count = 0
      rolls
        .each {|coords, contents|
          if contents == "@" && rolls.accessible?(coords)
            removed << coords
            remove_count += 1
            rolls.set(coords, ".")
          end
        }
      break if remove_count == 0
    end

    removed.count
  end

  class Diagram < Grid
    def initialize(input)
      super
      parse
      set_surrounding_neighbors
    end

    # @example 0,7
    #   diagram = new(Day04::EXAMPLE_INPUT)
    #   diagram.accessible? [0, 7]  #=> false
    # @example 0,2
    #   diagram = new(Day04::EXAMPLE_INPUT)
    #   diagram.accessible? [0, 2]  #=> true
    def accessible?(coords)
      neighbors_for(coords)
        .select { |_direction, neighbor| at(neighbor) == "@" }
        .count < 4
    end
  end

  EXAMPLE_INPUT = File.read("../inputs/day04-example-input.txt")
end
