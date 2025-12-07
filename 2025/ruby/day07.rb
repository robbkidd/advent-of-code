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

  attr_reader :entrance, :splitter_coords

  def initialize(input=nil)
    super
    @entrance = nil
    @splitter_coords = Set.new
    @beam_density = Hash.new { 0 }
  end

  # @example
  #   tachmani = new(Day07::EXAMPLE_INPUT)
  #   tachmani.parse
  #   tachmani.entrance #=> [0,7]
  #   tachmani.splitter_coords #=> Set[[2, 7], [4, 6], [4, 8], [6, 5], [6, 7], [6, 9], [8, 4], [8, 6], [8, 10], [10, 3], [10, 5], [10, 9], [10, 11], [12, 2], [12, 6], [12, 12], [14, 1], [14, 3], [14, 5], [14, 7], [14, 9], [14, 13]]
  def parse
    super { |coord, char|
      case char
      when "S" ; @entrance = coord
      when "^" ; @splitter_coords << coord
      else ; # keep calm and parse on
      end
    }
  end

  def track_beam
    @beam_density[@entrance] += 1

    @row_bounds
      .each do |row|
        next if row == @row_bounds.min # skip first row, that's where the beam enters

        @beam_density
          .select {|(beam_row, _), _| beam_row == row-1 } # beams from above
          .each do |(_, beam_col), density|
            if @splitter_coords.include?([row, beam_col])
              @beam_density[[row,beam_col-1]] += density
              @beam_density[[row,beam_col+1]] += density
            else
              @beam_density[[row,beam_col]] += density
            end
          end
    end
  end

  def beam_splits
    @splitter_coords
      .select { |(r,c)|
        @beam_density[[r-1,c]] > 0 # look above every splitter for beaminess
      }
      .count
  end

  def timeline_splits
    @beam_density
      .filter_map {|(r,c), density|
        density if r == @row_bounds.max # beam densities on manifold exit
      }
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
