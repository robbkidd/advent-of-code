require 'set'

class Day11
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input, :row_bounds, :column_bounds, :octopodes_step_states

  def initialize(input=nil)
    @octopodes_step_states = []
    @octopodes_step_states.push( parse(input || real_input) )

    @row_bounds,
    @column_bounds = @octopodes_step_states[0]
      .keys
      .transpose
      .map{ |dimension| Range.new(*dimension.minmax) }
  end

  # @example
  #   day.part1 #=> 1656
  def part1
    100
      .times
      .map { step }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 195
  def part2
    steps = 0
    until @octopodes_step_states[steps].values.uniq == [0] do
      step
      steps += 1
    end
    steps
  end

  def step
    octopi = @octopodes_step_states.last.dup

    octopi.each do |location, _|
      octopi[location] += 1
    end

    flashed = Set.new
    until octopi.values.all? {|power_level| power_level <= 9} do
      octopi
        .filter{|_, power_level| power_level > 9 }
        .each do |location, _|
          flashed.add(location)
          octopi[location] = 0
          neighboring_octopi(location).each do |adjacency|
            octopi[adjacency] += 1 unless flashed.include?(adjacency)
          end
        end
    end

    @octopodes_step_states.push(octopi)
    flashed.length
  end

  # @example
  #   GRID_OFFSETS.include?([0,0]) #=> false
  GRID_OFFSETS = [-1, -1, 0, 1, 1].permutation(2).to_a.uniq.freeze

  # @example doesn't go out of bounds
  #   day.neighboring_octopi([0,0]) #=> [[0, 1], [1, 0], [1, 1]]
  #   day.neighboring_octopi([9,9]) #=> [[8, 8], [8, 9], [9, 8]]
  # @example doesn't include the 'home' location
  #   day.neighboring_octopi([4,5]).include?([4,5]) #=> false
  def neighboring_octopi(location)
    GRID_OFFSETS.map{ |offset|
      location.zip(offset)
              .map { |p| p.reduce(&:+) }
    }
    .filter { |r, c|
      @row_bounds.cover?(r) && @column_bounds.cover?(c)
    }
  end

  def real_input
    File.read('../inputs/day11-input.txt')
  end

  # Updates @octopi with values from input
  # @example
  #   day.parse(EXAMPLE_INPUT)
  def parse(input)
    octopi = {}
    input
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index{ |row, r|
        row.each_with_index{ |power_level, c|
          octopi[[r,c]] = power_level
        }
      }
    octopi
  end

  # Print lowest points or basins?
  #
  # @example
  #   day.display_octogrid
  #
  # @example
  #   wee = Day11.new(WEE_GRID)
  #   wee.display_octogrid
  def display_octogrid(at_step=nil)
    octopi = if at_step
                @octopodes_step_states[at_step]
              else
                @octopodes_step_states.last
              end
    puts
    @row_bounds.each do |row|
      @column_bounds.each do |column|
        power_level = octopi[[row,column]]
        if power_level == 0
          print "\e[7m#{power_level}\e[0m"
        else
          print power_level
        end
      end
      puts
    end
    puts
  end

  EXAMPLE_INPUT = <<~INPUT
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
  INPUT

  WEE_GRID = <<~WEE
    11111
    19991
    19191
    19991
    11111
  WEE
end
