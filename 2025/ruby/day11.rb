require_relative 'day'

class Day11 < Day # >

  def rack
    @rack ||=
      input
        .split("\n")
        .map { |line| line.split(/:?\s/) }
        .each_with_object({}) { |devices, rack|
          rack[devices[0]] = devices[1..]
        }
  end

  # @example
  #   day.part1 #=> 5
  def part1
    path_length_from = -> (here) {
      if here == "out"
        1
      else
        rack[here].map { |output| path_length_from.(output) }.reduce(&:+)
      end
    }

    path_length_from.("you")
  end

  # @example
  #   day = new(EXAMPLE_INPUT2)
  #   day.part2 #=> 2
  def part2
    visit_cache = {}

    path_length_from = -> (here, must_visit:) {
      visit_cache[[here, must_visit]] ||=
        begin
          must_visit -= [here]
          if here == "out"
            must_visit.empty? ? 1 : 0
          else
            rack[here]
              .map { |output| path_length_from.(output, must_visit:) }
              .reduce(&:+)
          end
        end
    }

    path_length_from.("svr", must_visit: ["dac", "fft"])
  end

  EXAMPLE_INPUT = File.read("../inputs/day11-example-input.txt")
  EXAMPLE_INPUT2 = File.read("../inputs/day11-example-input2.txt")
end
