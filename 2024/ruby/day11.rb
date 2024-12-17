require_relative 'day'
require 'parallel'

class Day11 < Day # >

  # @example
  #   day.part1 #=> 55312
  def part1
    25
      .times
      .inject(input.scan(/\d+/)) { |stones, _n|
        stones = blink(stones) # the slow way
      }
      .length
  end

  # @example
  #   day.part2 #=> :no_example_answer_provided
  def part2
    75
      .times
      .inject(input.scan(/\d+/)) { |stones, n|
        stones = blink_faster(stones)
      }
      .values
      .reduce(&:+)
  end

  # @example
  #   day.blink(%w{125 17}) #=> %w{253000 1 7}
  def blink(stones)
    stones
      .flat_map { |stone|
        case
        when stone == '0' ; '1'
        when stone.length%2 == 0
          [ stone[0..stone.length/2-1] , stone[stone.length/2..].to_i.to_s ]
        else
          (stone.to_i * 2024).to_s
        end
      }
  end

  # @example
  #   once = day.blink_faster(%w{125 17}) #=> %w{253000 1 7}.tally
  #   twice = day.blink_faster(once)      #=> %w{253 0 2024 14168}.tally
  #   thrice = day.blink_faster(twice)    #=> %w{512072 1 20 24 28676032}.tally
  #   quatro = day.blink_faster(thrice)   #=> %w{512 72 2024 2 0 2 4 2867 6032}.tally
  def blink_faster(stones)
    case stones
    when Array ; stones = stones.tally
    when Hash ; # carry on
    else raise "lolwut: I can only blink at Arrays or Hashes, friend."
    end

    stones
      .inject(Hash.new(0)) { |newstones, (stone, count)|
        case
        when stone == '0'
          newstones['1'] += count
        when stone.length.even?
          newstones[stone[0...stone.length/2]] += count
          newstones[stone[stone.length/2..].to_i.to_s] += count
        else
          newstones[(stone.to_i * 2024).to_s] += count
        end
        newstones
      }
  end

  EXAMPLE_INPUT = File.read("../inputs/day11-example-input.txt")
end
