require_relative 'day'

class Day13 < Day # >
  attr_reader :claw_machines

  def initialize(*args)
    super
    @claw_machines =
      input
        .split("\n\n")
        .map { |stanza|
          stanza
            .scan(/\d+/)
            .map(&:to_i)
        }
  end

  # @example
  #   day.part1 #=> 480
  # @example parsed input expected
  #   day.claw_machines.first #=> [94, 34, 22, 67, 8400, 5400]
  def part1
    claw_machines
      .map { |ax, ay, bx, by, px, py|
        a_presses = (px * by - py * bx) / (ax * by - ay * bx)
        b_presses = (ax * py - ay * px) / (ax * by - ay * bx)
        if [ax * a_presses + bx * b_presses, ay * a_presses + by * b_presses] == [px, py]
          a_presses * 3 + b_presses
        else
          0
        end
      }
      .reduce(&:+)
  end

  def part2
    claw_machines
      .map { |ax, ay, bx, by, px, py|
        px = px + 10000000000000
        py = py + 10000000000000
        a_presses = (px * by - py * bx) / (ax * by - ay * bx)
        b_presses = (ax * py - ay * px) / (ax * by - ay * bx)
        if [ax * a_presses + bx * b_presses, ay * a_presses + by * b_presses] == [px, py]
          a_presses * 3 + b_presses
        else
          0
        end
      }
      .reduce(&:+)
  end

  EXAMPLE_INPUT = File.read("../inputs/day13-example-input.txt")
end
