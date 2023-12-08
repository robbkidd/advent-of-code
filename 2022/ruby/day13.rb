require_relative "day"
require "json"

class Day13 < Day
  # @example
  #   day.part1 #=> 13
  def part1
    SignalAnalyzer
      .new(input)
      .analyze
      .select { |pair| pair.in_right_order? }
      .map { |pair| pair.index }
      .reduce(&:+)
  end

  # @example
  #   day.part2
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
  INPUT
end

class SignalAnalyzer
  include Enumerable

  def initialize(input)
    @input = input
    @pairs =
      input
        .split("\n\n")
        .each_with_index
        .map do |stanza, index|
          left_in, right_in = stanza.split("\n")
          PacketPair.new(index + 1, left_in, right_in)
        end
  end

  def analyze
    each { |pair| pair.analyze }
    self
  end

  def each
    @pairs.each { |p| yield p }
  end

  class Packet
    def initialize(input_line)
      @input_line = input_line
      @parsed = nil
    end

    def parse
      @parsed ||=
        if conforms_to_spec?
          JSON.parse(@input_line)
        else
          raise "Non-conforming packet: #{@input_line}"
        end
    end

    def conforms_to_spec?
      !@input_line.match?(/[^\[\],\d]/)
    end
  end

  class PacketPair
    attr_reader :index

    def initialize(index, left_in, right_in)
      @index = index
      @left_in = left_in
      @left = Packet.new(@left_in)
      @right_in = right_in
      @right = Packet.new(@right_in)

      @diag = []
      @in_right_order = nil
    end

    def diag
      @diag.join("\n").gsub(", ", ",")
    end

    def in_right_order?
      @in_right_order ||= (analyze <= 0)
    end

    # @example
    #   p = new(8, "[1,[2,[3,[4,[5,6,7]]]],8,9]", "[1,[2,[3,[4,[5,6,0]]]],8,9]")
    #   result = p.analyze
    #   p.diag    #=> Day13::EXAMPLE_RESULTS[8].strip
    #   result    #=> 1
    def analyze
      @diag = []
      @diag << "== Pair #{@index} =="
      compare(@left.parse, @right.parse)
    end

    def compare(left, right, depth = 0)
      case [left.class, right.class]
      when [Integer, NilClass], [Array, NilClass]
        @diag << "#{"  " * depth}- Right side ran out of items,  so inputs are not in the right order"
        1
      when [NilClass, Integer], [NilClass, Array]
        @diag << "#{"  " * depth}- Left side ran out of items,  so inputs are in the right order"
        -1
      when [Integer, Integer]
        @diag << "#{"  " * depth}- Compare #{left} vs #{right}"

        case result = left <=> right
        when -1
          if depth > 0
            @diag << "#{"  " * (depth + 1)}- Left side is smaller,  so inputs are in the right order"
          end
          return result
        when 1
          if depth > 0
            @diag << "#{"  " * (depth + 1)}- Right side is smaller,  so inputs are not in the right order"
          end
          return result
        end
      when [Array, Array]
        @diag << "#{"  " * depth}- Compare #{left} vs #{right}"
        ls_and_rs = left.zip(right) #.tap { |hey| puts hey.inspect }

        ls_and_rs.each do |(l, r)|
          case result = compare(l, r, depth + 1)
          when -1
            return result
          when 1
            return result
          end
        end
        if depth == 0
          @diag << "#{"  " * (depth + 1)}- Left side ran out of items,  so inputs are in the right order"
          return -1
        end
      when [Array, Integer]
        @diag << "#{"  " * depth}- Compare #{left} vs #{right}"
        @diag << "#{"  " * (depth + 1)}- Mixed types; convert right to [#{right}] and retry comparison"

        compare(left, [right], depth + 1)
      when [Integer, Array]
        @diag << "#{"  " * depth}- Compare #{left} vs #{right}"
        @diag << "#{"  " * (depth + 1)}- Mixed types; convert left to [#{left}] and retry comparison"

        compare([left], right, depth + 1)
      else
        raise "case_not_covered_yet: #{left.inspect} vs #{right.inspect}"
      end
    end
  end
end

class Day13
  EXAMPLE_RESULTS = <<~RESULTS.split("\n\n")
bump the index

== Pair 1 ==
- Compare [1,1,3,1,1] vs [1,1,5,1,1]
  - Compare 1 vs 1
  - Compare 1 vs 1
  - Compare 3 vs 5
    - Left side is smaller, so inputs are in the right order

== Pair 2 ==
- Compare [[1],[2,3,4]] vs [[1],4]
  - Compare [1] vs [1]
    - Compare 1 vs 1
  - Compare [2,3,4] vs 4
    - Mixed types; convert right to [4] and retry comparison
    - Compare [2,3,4] vs [4]
      - Compare 2 vs 4
        - Left side is smaller, so inputs are in the right order

== Pair 3 ==
- Compare [9] vs [[8,7,6]]
  - Compare 9 vs [8,7,6]
    - Mixed types; convert left to [9] and retry comparison
    - Compare [9] vs [8,7,6]
      - Compare 9 vs 8
        - Right side is smaller, so inputs are not in the right order

== Pair 4 ==
- Compare [[4,4],4,4] vs [[4,4],4,4,4]
  - Compare [4,4] vs [4,4]
    - Compare 4 vs 4
    - Compare 4 vs 4
  - Compare 4 vs 4
  - Compare 4 vs 4
  - Left side ran out of items, so inputs are in the right order

== Pair 5 ==
- Compare [7,7,7,7] vs [7,7,7]
  - Compare 7 vs 7
  - Compare 7 vs 7
  - Compare 7 vs 7
  - Right side ran out of items, so inputs are not in the right order

== Pair 6 ==
- Compare [] vs [3]
  - Left side ran out of items, so inputs are in the right order

== Pair 7 ==
- Compare [[[]]] vs [[]]
  - Compare [[]] vs []
    - Right side ran out of items, so inputs are not in the right order

== Pair 8 ==
- Compare [1,[2,[3,[4,[5,6,7]]]],8,9] vs [1,[2,[3,[4,[5,6,0]]]],8,9]
  - Compare 1 vs 1
  - Compare [2,[3,[4,[5,6,7]]]] vs [2,[3,[4,[5,6,0]]]]
    - Compare 2 vs 2
    - Compare [3,[4,[5,6,7]]] vs [3,[4,[5,6,0]]]
      - Compare 3 vs 3
      - Compare [4,[5,6,7]] vs [4,[5,6,0]]
        - Compare 4 vs 4
        - Compare [5,6,7] vs [5,6,0]
          - Compare 5 vs 5
          - Compare 6 vs 6
          - Compare 7 vs 0
            - Right side is smaller, so inputs are not in the right order
RESULTS
end
