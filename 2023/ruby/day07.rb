require_relative 'day'

class Day07 < Day # >

  # @example
  #   day.part1 #=> 6440
  def part1
    input
      .each_line
      .map { |line| Hand.new(*line.split(" ")) }
      .sort
      .map.with_index(1) { |hand, idx| hand.bid * idx }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 5905
  def part2
    input
      .each_line
      .map { |line| JokersWild.new(*line.split(" ")) }
      .sort
      .map.with_index(1) { |hand, idx| hand.bid * idx }
      .reduce(&:+)
  end


  EXAMPLE_INPUT = <<~INPUT
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
  INPUT
end

class Hand
  include Comparable

  attr_reader :input, :cards, :tally, :type, :bid
  # @example
  #   hand = Hand.new("AAAAA")
  #   hand.cards #=> ["A","A","A","A","A"]
  #   hand.tally #=> {"A" => 5}
  # @example with bid
  #   hand = Hand.new("AAAAA", "564")
  #   hand.bid #=> 564
  def initialize(input, bid="")
    @input = input
    @cards = input.chars
    @tally = @cards.tally
    @type = determine_type

    @bid = bid.to_i
  end

  # @example
  #   hand = Hand.new("QJJQ2", "42")
  #   hand.determine_type #=> [2,2,1]
  def determine_type
    @tally.values.sort.reverse
  end

  CARD_LABELS = %w{A K Q J T 9 8 7 6 5 4 3 2}
  CARD_STRENGTH = Hash[CARD_LABELS.reverse.zip((0..CARD_LABELS.length))]

  def card_strength(card)
    CARD_STRENGTH.fetch(card)
  end

  # @example different types
  #   Hand.new("AA8AA") > Hand.new("23432") #=> true
  # @example same type, different cards
  #   Hand.new("33332").type #=> [4,1]
  #   Hand.new("2AAAA").type #=> [4,1]
  #   %w{33332 2AAAA}.map{|h| Hand.new(h)}.sort.map(&:input) #=> %w{2AAAA 33332}
  def <=>(other)
    if self.type != other.type
      # compare types, e.g. [3,1,1] vs [2,2,1]
      self.type
        .zip(other.type) # now it's [[3,2], [1,2], [1,1]] or 3 vs 2
        .each do |counts|
          cmp = counts[0] <=> counts[1]
          return cmp if cmp != 0
        end
      raise("fell through comparing type")
    else
      # compare cards, e.g. ["3","3","3","3","2"] vs ["2","A","A","A","A"]
      self.cards
        .zip(other.cards)
        .each do |card_pair| # now it's [["3","2"], ["3","A"], ...] or 3 vs 2
          cmp = card_strength(card_pair[0]) <=> card_strength(card_pair[1])
          return cmp if cmp != 0
        end
      raise("fell through comparing cards")
    end

    raise("fell through the whole compare")
  end
end

# @example comparisons
#    JokersWild.new("JJJJJ") < JokersWild.new("22222") #=> true
#    JokersWild.new("JJJJJ") < JokersWild.new("2JJJJ") #=> true
# example edge cases
#    %w{AJJ94 KKK23 A2223}.map{|h| JokersWild.new(h) }.sort.map(&:input) #=> %w{KKK23 AJJ94 A2223}
class JokersWild < Hand
  # redefine card strength constants
  CARD_LABELS = %w{A K Q T 9 8 7 6 5 4 3 2 J}
  CARD_STRENGTH = Hash[CARD_LABELS.reverse.zip((0..CARD_LABELS.length))]

  # override with new constant
  # @example
  #   jw = JokersWild.new("QKKQ2") # input doesn't matter here
  #   jw.card_strength("A") > jw.card_strength("J") #=> true
  #   jw.card_strength("2") > jw.card_strength("J") #=> true
  def card_strength(card)
    CARD_STRENGTH.fetch(card)
  end

  # @example no jokers
  #   JokersWild.new("QKKQ2").type #=> [2,2,1]
  # @example five of a kind
  # @example all jokers
  #   JokersWild.new("JJJJJ").type #=> [5]
  # @example four of a kind
  #   JokersWild.new("QJJQ2").type #=> [4,1]
  #   JokersWild.new("T55J5").type #=> [4,1]
  #   JokersWild.new("KTJJT").type #=> [4,1]
  #   JokersWild.new("QQQJA").type #=> [4,1]
  #   JokersWild.new("96J66").type #=> [4,1]
  # @example full house
  #   JokersWild.new("J22QQ").type #=> [3,2]
  # @example three of a kind
  #   JokersWild.new("QJ23Q").type #=> [3,1,1]
  #   JokersWild.new("AJJ94").type #=> [3,1,1]
  #   JokersWild.new("J6569").type #=> [3,1,1]
  #   JokersWild.new("JKK92").type #=> [3,1,1]
  # @example two pair
  #   JokersWild.new("KK677").type #=> [2,2,1]
  # @example one pair
  #   JokersWild.new("2345J").type #=> [2,1,1,1]
  #   JokersWild.new("J1234").type #=> [2,1,1,1]
  #   JokersWild.new("32T3K").type #=> [2,1,1,1]
  def determine_type
    return super unless tally.keys.include?("J")

    not_wild_tally = tally.dup
    joker_count = not_wild_tally.delete("J")

    return [5] if joker_count == 5

    best_other_card, count = not_wild_tally.max_by{ |label, count| count }
    not_wild_tally[best_other_card] += joker_count
    not_wild_tally.values.sort.reverse
  end
end
