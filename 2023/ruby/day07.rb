require_relative 'day'

class Day07 < Day # >

  # @example
  #   day.part1 #=> 6440
  def part1
    input
      .each_line
      .map { |line| Hand.new(*line.split(" ")) }
      .sort
      .map
      .with_index(1) { |hand, idx| hand.bid * idx }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
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

  attr_reader :cards, :tally, :type, :bid
  # @example
  #   hand = Hand.new("AAAAA")
  #   hand.cards #=> ["A","A","A","A","A"]
  #   hand.tally #=> {"A" => 5}
  # @example with bid
  #  hand = Hand.new("AAAAA", "564")
  #  hand.bid #=> 564
  def initialize(input, bid="")
    @cards = input.chars
    @tally = @cards.tally
    @type = @tally.values.sort.reverse

    @bid = bid.to_i
  end

  TYPES = [
    [5], # :five_of_a_kind,
    [4,1], # :four_of_a_kind,
    [3,2], # :full_house,
    [3,1,1], # :three_of_a_kind,
    [2,2,1], # :two_pair,
    [2,1,1,1], # :one_pair,
    [1,1,1,1,1], # :high_card,
  ]

  LABELS = %w{A K Q J T 9 8 7 6 5 4 3 2}
  LABEL_STRENGTH = Hash[LABELS.reverse.zip((0..LABELS.length))]

  # @example different types
  #   c1 = Hand.new("AA8AA")
  #   c2 = Hand.new("23432")
  #   c1 > c2 #=> true
  # @example same type, different cards
  #   c1 = Hand.new("33332")
  #   c1.type #=> [4,1]
  #   c2 = Hand.new("2AAAA")
  #   c2.type #=> [4,1]
  #   c1 > c2 #=> true
  def <=>(other)
    if self.type != other.type
      # compare types
      self.type
        .zip(other.type)
        .each do |this_count, other_count|
          next if this_count == other_count

          return this_count <=> other_count
        end
        raise("fell through comparing type")
    else
      # compare cards
      self.cards
      .zip(other.cards)
      .each do |this_card, other_card|
        next if this_card == other_card
        return LABEL_STRENGTH.fetch(this_card) <=> LABEL_STRENGTH.fetch(other_card)
      end
      raise("fell through comparing cards")
    end

    raise("fell through the whole compare")
  end
end
