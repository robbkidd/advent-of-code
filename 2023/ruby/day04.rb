require_relative 'day'

class Day04 < Day # >

  # @example
  #   day.part1 #=> 13
  def part1
    card_match_wins
      .map { |matches| 0 < matches ? 2**(matches-1) : 0 }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 30
  def part2
    copies = Array.new(card_match_wins.length, 0)

    card_match_wins
      .each_with_index do |wins, card|
        copies[card] = copies[card] + 1   # count the original

        next unless wins > 0              # and that's it unless it's a winner

        ((card+1)..(card+wins)).each do |win|        # for each next card won
          copies[win] = copies[win] + (copies[card]) # add to that card's count however many of this card we have
        end
      end

    copies
      .reduce(&:+)
  end

  def card_match_wins
    @card_match_wins ||=
      input
        .split("\n")
        .map { |line| line.split(/\:\s+/)[1] }
        .map { |scratch_offs|
              scratch_offs
                .split(/\s+\|\s+/)
                .map { |numbers|
                  numbers
                    .split(/\s+/)
                    .map(&:to_i)
                }
                .reduce(&:&)
                .length
        }
  end

  EXAMPLE_INPUT = <<~INPUT
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  INPUT
end
