require_relative 'day'
require 'parallel'

class Day22 < Day # >

  # @example
  #   day.part1 #=> 37327623
  def part1
    initial_secret_numbers = input.split("\n").map(&:to_i)
    Parallel.map(initial_secret_numbers) { |initial_secret_number|
      2000.times.inject(initial_secret_number) { |secret_number, _|
        secret_number = ((secret_number * 64) ^ secret_number) % 16777216
        secret_number = ((secret_number / 32).floor ^ secret_number) % 16777216
        secret_number = ((secret_number * 2048) ^ secret_number) % 16777216
      }
    }.reduce(&:+)
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day22-example-input.txt")
end
