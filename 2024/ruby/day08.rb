require_relative 'day'
require_relative 'grid'
require 'matrix'

class Day08 < Day # >
  attr_reader :map, :antenna_locations

  def initialize(*args)
    super

    @antenna_locations = Hash.new { |hash, frequency|
      hash[frequency] = [] # the future home of list of grid locations
    }

    @map =
      Grid
        .new(input)
        .parse do |coords, char|
          if %r{\w}.match? char # antenna frequencies are word characters
            antenna_locations[char] << Vector.elements(coords)
          end
        end
  end

  # @example
  #   day.part1 #=> 14
  # @example two antennas
  #   day = new(EXAMPLE_TWO_ANTENNAS)
  #   day.part1 #=> 2
  # @example three antennas
  #   day = new(EXAMPLE_THREE_ANTENNAS)
  #   day.part1 #=> 4
  def part1
    antinodes =
      antenna_locations
        .map {|frequency, locations|
          locations
            .combination(2)
            .flat_map {|a,b|
              diff = a - b
              [ a + diff, b - diff ]
            }
            .uniq
            .select { |antinode| map.cover? antinode.to_a }
        }
        .flatten
        .uniq
        .map(&:to_a)

    if ENV['DEBUG']
      puts "\n" + map.to_s { |coords, value|
        if antinodes.include?(coords)
          value == '.' ? "\e[41m\e[1m#\e[0m" : "\e[41m\e[1m#{value}\e[0m"
        else
          "\e[32m#{value}\e[0m"
        end
      }
    end

    antinodes.count
  end

  # @example
  #   day.part2 #=> 34
  # @example resonant harmonics
  #   day = new(EXAMPLE_RESONANT_HARMONICS)
  #   day.part2 #=> 9
  def part2
    antinodes =
      antenna_locations
        .flat_map {|frequency, locations|
          locations
            .combination(2)
            .flat_map {|a,b|
              puts [a,b].inspect if ENV['DEBUG']
              diff = a - b
              puts diff.inspect if ENV['DEBUG']
              upwards = Enumerator.produce(a) {|antinode| antinode + diff }
              downwards = Enumerator.produce(b) {|antinode| antinode - diff }

              upwards.take_while { map.cover?(_1) } +
                downwards.take_while { map.cover?(_1) }
            }
            .uniq
        }
        .uniq
        .map(&:to_a)

    if ENV['DEBUG']
      puts "\n" + map.to_s { |coords, value|
        if antinodes.include?(coords)
          value == '.' ? "\e[41m\e[1m#\e[0m" : "\e[41m\e[1m#{value}\e[0m"
        else
          "\e[32m#{value}\e[0m"
        end
      }
    end

    antinodes.count
  end

  EXAMPLE_INPUT = File.read("../inputs/day08-example-input.txt")

  EXAMPLE_TWO_ANTENNAS = <<~EXAMPLE
    ..........
    ...#......
    ..........
    ....a.....
    ..........
    .....a....
    ..........
    ......#...
    ..........
    ..........
  EXAMPLE

  EXAMPLE_THREE_ANTENNAS = <<~EXAMPLE
    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......#...
    ..........
    ..........
  EXAMPLE

  EXAMPLE_RESONANT_HARMONICS = <<~EXAMPLE
    T....#....
    ...T......
    .T....#...
    .........#
    ..#.......
    ..........
    ...#......
    ..........
    ....#.....
    ..........
  EXAMPLE
end
