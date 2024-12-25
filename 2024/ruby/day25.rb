require_relative 'day'

class Day25 < Day # >

  # @example
  #   day.part1 #=> 3
  def part1
    locks = []
    keys = []

    input
      .split("\n\n")
      .map { |schematic| [ schematic.end_with?("#####") ? :key : :lock , schematic ] }
      .each { |type, schematic|
          schematic
            .split("\n")
            .map { |line| line.chars }
            .transpose
            .map {|column| column.count("#") - 1 }
            .tap { |heights|
              case type
              when :lock
                locks << heights
              when :key
                keys << heights
              end
            }
      }

    keys
      .reduce(0) { |sum, key|
        sum +
          locks
            .reduce(0) {|fits, lock|
              fits + (key.zip(lock).all? { |tooth, pin| tooth + pin < 6} ? 1 : 0)
          }
      }
  end

  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day25-example-input.txt")
end
