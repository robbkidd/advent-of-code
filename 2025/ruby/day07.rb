require_relative 'day'
require_relative 'grid'
require_relative 'ugly_sweater'

class Day07 < Day # >

  # @example
  #   day.part1 #=> 21
  def part1
    @tachy = TachyonManifold.new(input).parse
    @tachy.track_beam
    puts "\n" + @tachy.to_s if ENV['DEBUG']
    @tachy.beam_splits
  end

  # @example
  #   day.part1
  #   day.part2 #=> 40
  def part2
    @tachy.timeline_splits
  end

  EXAMPLE_INPUT = File.read("../inputs/day07-example-input.txt")
end

class TachyonManifold < Grid
  include UglySweater

  attr_reader :entrance, :splitter_coords, :splitters_by_row, :beams_by_row

  def self.example
    new(Day07::EXAMPLE_INPUT).parse
  end

  def initialize(input=nil)
    super
    @entrance = nil
    @splitter_coords = Set.new
  end

  # @example
  #   tachmani = new(Day07::EXAMPLE_INPUT)
  #   tachmani.parse
  #   tachmani.entrance #=> [0,7]
  #   tachmani.splitter_coords #=> Set[[2, 7], [4, 6], [4, 8], [6, 5], [6, 7], [6, 9], [8, 4], [8, 6], [8, 10], [10, 3], [10, 5], [10, 9], [10, 11], [12, 2], [12, 6], [12, 12], [14, 1], [14, 3], [14, 5], [14, 7], [14, 9], [14, 13]]
  #   tachmani.splitters_by_row[4] #=> Set[6,8]
  #   tachmani.beams_by_row[0] #=> Set[7]
  def parse
    super { |coord, char|
      case char
      when "S" ; @entrance = coord
      when "^" ; @splitter_coords << coord
      else ; # keep calm and parse on
      end
    }

    @beams_by_row = Array.new(@row_bounds.count) { Set.new }
    @beams_by_row[@entrance[0]] << @entrance[1]

    @beam_density = Hash.new { 0 }
    @beam_density[@entrance] += 1

    @splitters_by_row = Array.new(@row_bounds.count) { Set.new }
    @splitter_coords.each { |(r,c)|
      @splitters_by_row[r] << c
    }

    @beam_splits = 0

    self
  end

  def track_beam
    @row_bounds.to_a[1..].each { |r|
      @beams_by_row[r-1].each { |c|
        if @splitters_by_row[r].include?(c)
          @beams_by_row[r] << c-1
          @beams_by_row[r] << c+1
          @beam_splits += 1
          @beam_density[[r,c-1]] += @beam_density[[r-1,c]]
          @beam_density[[r,c+1]] += @beam_density[[r-1,c]]
        else
          @beams_by_row[r] << c
          @beam_density[[r,c]] += @beam_density[[r-1,c]]
        end
      }
    }
  end

  def beam_splits
    @beam_splits
  end

  def timeline_splits
    @beam_density
      .filter_map {|(r,c), density| density if r == @row_bounds.max }
      .reduce(&:+)
  end

  def to_s
    super { |(r,c), char|
      case
      when char == "S" ; char.make_it_green
      when @splitter_coords.include?([r,c]) ; char.make_it_red.make_it_bold
      when @beam_density[[r,c]] > 0 ; "|".make_it_green
      else ; char
      end
    }
  end

end
