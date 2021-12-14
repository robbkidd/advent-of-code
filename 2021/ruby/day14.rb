class Day14
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example
  #   day.part1 #=> 1_588
  def part1
    polymer = Polymer.new(*@input.split("\n\n"))
    10.times { polymer.insert }
    polymer
      .element_tally
      .minmax_by { |_element, count| count }
      .map { |_element, count| count }
      .sort
      .reverse
      .reduce(&:-)
  end

  # @example
  #   day.part2 #=> 2188189693529
  def part2
    polymer = Polymer.new(*@input.split("\n\n"))
    40.times { polymer.insert }
    polymer
      .element_tally
      .minmax_by { |_element, count| count }
      .map { |_element, count| count }
      .sort
      .reverse
      .reduce(&:-)
  end

  def parse_input
  end

  def real_input
    File.read('../inputs/day14-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
  INPUT
end

class Polymer
  attr_reader :pairs

  def initialize(template='', rules='')
    parsed_template = parse_template(template)
    @pairs = parsed_template[:pairs]

    @opener = parsed_template[:opener]
    @closer = parsed_template[:closer]

    @rules = parse_rules(rules)
  end

  # @example 1 step
  #   template, rules = Day14::EXAMPLE_INPUT.split("\n\n")
  #   p = Polymer.new(template, rules)
  #   p.insert
  #   p.pairs #=> 'NCNBCHB'.chars.each_cons(2).tally
  # @example 2 steps
  #   template, rules = Day14::EXAMPLE_INPUT.split("\n\n")
  #   p = Polymer.new(template, rules)
  #   p.insert
  #   p.insert
  #   p.pairs #=> 'NBCCNBBBCBHCB'.chars.each_cons(2).tally
  # @example 4 steps
  #   template, rules = Day14::EXAMPLE_INPUT.split("\n\n")
  #   p = Polymer.new(template, rules)
  #   4.times { p.insert }
  #   p.pairs #=> 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'.chars.each_cons(2).tally
  def insert
    new_pairs = Hash.new(0)
    @pairs.each do |pair, count|
        insertion = @rules[pair]
        new_pairs[[pair.first, insertion]] += count
        new_pairs[[insertion, pair.last]] += count
    end
    @pairs = new_pairs
  end

  # @example 10 step element count
  #   template, rules = Day14::EXAMPLE_INPUT.split("\n\n")
  #   p = Polymer.new(template, rules)
  #   10.times { p.insert }
  #   p.element_tally['B'] #=> 1_749
  #   p.element_tally['N'] #=> 865
  #   p.element_tally['H'] #=> 161
  #   p.element_tally['C'] #=> 298
  def element_tally
    @pairs.each_with_object(Hash.new(0)) do |(pair, count), element_tally|
      # assemble the count from the first element of each pair
      element_tally[pair.first] += count
    end.tap { |tally|
      # then tack on the closing element since the second of each pair was ignored
      tally[@closer] += 1
    }
  end

  # @example
  #   p = Polymer.new
  #   p.parse_template('NNCB') #=> {opener: 'N', closer: 'B', pairs: {["N", "N"]=>1, ["N", "C"]=>1, ["C", "B"]=>1} }
  def parse_template(template)
    chars = template.chars
    { opener: chars.first,
      closer: chars.last,
      pairs: chars.each_cons(2).to_a.tally
    }
  end

  # @example
  #   p = Polymer.new
  #   p.parse_rules("CH -> B\nHH -> N\n") #=> {['C','H'] => 'B', ['H','H'] => 'N'}
  def parse_rules(rules)
    rules
      .split("\n")
      .each_with_object({}) do |line, rules|
        pair, element = line.split(" -> ")
        rules[pair.chars] = element
      end
  end
end
