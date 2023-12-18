require_relative 'day'

class Day16 < Day # >

  # @example
  #   day.part1 #=> 46
  def part1
    c = Contraption.new(input)
    c.beam_bounces_around([0, -1], Contraption::RIGHTWARDS)
    puts c
    c.energized_count
  end

  # example
  #   day.part2 #=> '?'
  def part2
  end

  # slashes in the input are messing with my routine today
  EXAMPLE_INPUT = File.read("../inputs/day16-input-example.txt")
end

class Contraption
  require 'matrix'
  require 'set'
  require_relative 'grid'
  require_relative 'ugly_sweater'

  attr_reader :grid
  # @example
  #   c = new(Day16::EXAMPLE_INPUT)
  #   c.grid.to_s #=> Day16::EXAMPLE_INPUT
  def initialize(input)
    @input = input
    @grid = Grid.new(input)

    @grid.parse do |coords, char|
      @grid.set(coords, Tile.new(char))
    end
  end

  # @example
  #   t = new("?")
  #   t.visit_from([0,1])
  #   t.visited_from?([-1, 0]) #=> false
  class Tile
    attr_reader :type
    def initialize(type)
      @type = type
      @visits = Set.new
    end
    def visited_from?(direction) ; @visits.include?(direction) ; end
    def visited? ; !@visits.empty? ; end
    def visit_from(direction) ; @visits << direction ; end
    def to_s ; if visited? ; type.make_it_red else type end ; end
    def deconstruct_keys(keys) ; {type: @type, visits: @visits} ; end
  end

  def energized_count
    @grid
      .filter_map { |_coords, tile| 1 if tile.visited? }
      .reduce(&:+)
  end

  UPWARDS    = [-1, 0]
  DOWNWARDS  = [ 1, 0]
  LEFTWARDS  = [ 0,-1]
  RIGHTWARDS = [ 0, 1]

  DIRECTIONS = [UPWARDS, DOWNWARDS, LEFTWARDS, RIGHTWARDS]

  # @example
  #   c = new(Day16::EXAMPLE_INPUT)
  #   c.beam_bounces_around([0,-1], RIGHTWARDS)
  #   c.grid.at([0,1]).visited? #=> true
  #   c.grid.at([1,1]).visited? #=> true
  # @example skips_off_the_grid
  #   c = new(Day16::EXAMPLE_INPUT)
  #   c.beam_bounces_around([0,0], LEFTWARDS) #=> nil
  def beam_bounces_around(from, direction)
    to_coords, to_tile = move_to(from, direction)
    return unless to_coords && to_tile
    return if to_tile.visited_from?(direction)

    to_tile.visit_from(direction)

    case {tile: to_tile.type, dir: direction}
    in tile: "|", dir: dir if [LEFTWARDS, RIGHTWARDS].include?(dir)
      beam_bounces_around(to_coords, UPWARDS)
      beam_bounces_around(to_coords, DOWNWARDS)
    in tile: "-", dir: dir if [UPWARDS, DOWNWARDS].include?(dir)
      beam_bounces_around(to_coords, LEFTWARDS)
      beam_bounces_around(to_coords, RIGHTWARDS)
    in tile: "\\", dir: LEFTWARDS
      beam_bounces_around(to_coords, UPWARDS)
    in tile: "\\", dir: RIGHTWARDS
      beam_bounces_around(to_coords, DOWNWARDS)
    in tile: "\\", dir: UPWARDS
      beam_bounces_around(to_coords, LEFTWARDS)
    in tile: "\\", dir: DOWNWARDS
      beam_bounces_around(to_coords, RIGHTWARDS)
    in tile: "/", dir: LEFTWARDS
      beam_bounces_around(to_coords, DOWNWARDS)
    in tile: "/", dir: RIGHTWARDS
      beam_bounces_around(to_coords, UPWARDS)
    in tile: "/", dir: UPWARDS
      beam_bounces_around(to_coords, RIGHTWARDS)
    in tile: "/", dir: DOWNWARDS
      beam_bounces_around(to_coords, LEFTWARDS)
    else
      beam_bounces_around(to_coords, direction)
    end
  end

  # @example
  #   c = new("")
  #   c.direction_was([3,2], [2,2]) #=> UPWARDS
  # @example accepts_vectors_if_i_want_em
  #   c = new("")
  #   c.direction_was(Vector[3,2], [2,2]) #=> UPWARDS
  #   c.direction_was([5,9],Vector[5,10]) #=> RIGHTWARDS
  def direction_was(from, to)
    (Vector.elements(to, copy: false) - Vector.elements(from, copy: false)).to_a
  end

  def move_to(from, direction)
    coords = (Vector.elements(from, copy: false) +
              Vector.elements(direction, copy: false)).to_a
    [coords, @grid.at(coords)]
  rescue KeyError
    [nil, nil]
  end


  def to_s
    @grid.to_s
  end
end
