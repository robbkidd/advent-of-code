require_relative 'day'
require 'set'

class Day23 < Day # >

  # @example
  #   day.part1 #=> 7
  def part1
    network = Hash.new { |h, k| h[k] = [] }
    input
      .split("\n")
      .each do |line|
        a, b = line.split("-")
        network[a] << b
        network[b] << a
      end

    triads = Set.new
    network
      .select { |hosts, _| hosts.start_with?("t") }
      .each { |t_host, hops_1| # t_host -> hop_1 -> hop_2 -> t_host
        hops_1
          .each { |hop_1|
            network[hop_1]
              .each { |hop_2|
                if network[hop_2].any? { |hop_3| hop_3 == t_host }
                  triads.add(Set.new([t_host, hop_1, hop_2]))
                end
              }
          }
      }
    triads.count
  end

  # @example
  #   day.part2 #=> 'co,de,ka,ta'
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day23-example-input.txt")
end
