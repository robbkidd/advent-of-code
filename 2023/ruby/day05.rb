require_relative 'day'

class Day05 < Day # >

  # @example
  #   day.part1 #=> 35
  def part1
    maps = parse

    maps["seeds"]
      .map { maps["seed-to-soil"].convert(_1) }
      .map { maps["soil-to-fertilizer"].convert(_1) }
      .map { maps["fertilizer-to-water"].convert(_1) }
      .map { maps["water-to-light"].convert(_1) }
      .map { maps["light-to-temperature"].convert(_1) }
      .map { maps["temperature-to-humidity"].convert(_1) }
      .map { maps["humidity-to-location"].convert(_1) }
      .min
  end

  # @example
  #   day.part2 #=> 46
  def part2
    maps = parse

    maps["seeds"]
      .each_slice(2)
      .map { |start, length|
        min = Float::INFINITY
        i = 0
        while i < length do
          location, skip =
            [start + i]
              .map{ maps["seed-to-soil"]           .convert_with_skip(_1)  } # no skip to start
              .map{ maps["soil-to-fertilizer"]     .convert_with_skip(*_1) } # <- from here on _1
              .map{ maps["fertilizer-to-water"]    .convert_with_skip(*_1) } # is [previous_conversion, skip]
              .map{ maps["water-to-light"]         .convert_with_skip(*_1) }
              .map{ maps["light-to-temperature"]   .convert_with_skip(*_1) }
              .map{ maps["temperature-to-humidity"].convert_with_skip(*_1) }
              .map{ maps["humidity-to-location"]   .convert_with_skip(*_1) }
              .first

          min = location if location < min
          i = i + skip if 0 < skip
          i = i + 1
        end
        min
      }
      .min
  end

  def parse
    maps = {}

    input
      .split("\n\n") # separate each paragraph/stanza
      .each do |stanza|
        lines = stanza.split("\n")

        if lines.first.match(/^seeds: \d/)
          maps["seeds"] = lines.first.split(": ")[1].split(/\s+/).map(&:to_i)
        else
          map_title = lines.shift.split(" ")[0]
          maps[map_title] = Mapper.new(map_title, lines)
        end
      end

    maps
  end


  class Mapper
    attr_reader :map_title, :maps

    def initialize(map_title, maps)
      @map_title = map_title
      @maps = maps
                .map { |line| line.split(" ").map(&:to_i) }
                .map { |dest_start, source_start, range_length|
                  [ Range.new(source_start, (source_start+range_length-1)), dest_start ]
                }
    end

    # @example
    #   mapper = Day05::Mapper.new("test", ["50 98 2", "52 50 48"])
    #   mapper.convert(79) #=> 81
    def convert(input)
      maps.each do |source_range, dest_start|
        next unless source_range.cover?(input)
        return dest_start + (input - source_range.min)
      end

      return input
    end

    # @example seed-to-soil
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["seed-to-soil"].convert_with_skip(82) #=> [84, 15]
    # @example soil-to-fertilizer
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["soil-to-fertilizer"].convert_with_skip(84, 15) #=> [84, 15]
    # @example fertilizer-to-water
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["fertilizer-to-water"].convert_with_skip(84, 15) #=> [84, 15]
    # @example water-to-light
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["water-to-light"].convert_with_skip(84, 15) #=> [77, 10]
    # @example light-to-temperature
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["light-to-temperature"].convert_with_skip(77, 10) #=> [45, 10]
    # @example temperature-to-humidity
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["temperature-to-humidity"].convert_with_skip(45, 10) #=> [46, 10]
    # @example humidity-to-location
    #  maps = Day05.new(Day05::EXAMPLE_INPUT).parse
    #  maps["humidity-to-location"].convert_with_skip(46, 10) #=> [46, 9]
    #
    # logic copied enthusiastically from Brandon Mitchell; I couldn't figure it out
    def convert_with_skip(input, skip=-1)
      maps.each do |source_range, dest_start|
        if source_range.cover?(input)
          if skip && skip > source_range.size - (input - source_range.min) - 1
            skip = source_range.size - (input - source_range.min) - 1
          end
          return [dest_start + (input - source_range.min), skip]
        end
        if input < source_range.min && (skip < 0 || skip > source_range.min - input -1)
          skip = source_range.min - input - 1
        end
      end

      return [input, skip]
    end
  end

  EXAMPLE_INPUT = <<~INPUT
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
  INPUT
end
