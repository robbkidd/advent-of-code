class Day08
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :entries

  def initialize(input=nil)
    @entries = parse_input(input || real_input)
  end

  # @example
  #   d = Day08.new(EXAMPLE_INPUT)
  #   d.part1 #=> 26
  def part1
    entries
      .map { |entry|
        entry[:output]
          .filter { |segments| [2, 3, 4, 7].include?(segments.length) }
      }
      .flatten
      .count
  end

  # @example
  #   d = Day08.new(EXAMPLE_INPUT)
  #   d.part2 #=> 61229
  def part2
    entries
      .map { |entry| decode_output(entry) }
      .reduce(&:+)
  end

  # @example
  #   d = Day08.new(EXAMPLE_INPUT)
  #   d.entries.map{|e| d.decode_output(e) } #=> [8394, 9781, 1197, 9361, 4873, 8418, 4548, 1625, 8717, 4315]
  def decode_output(entry)
    mapping = WireMap.new(entry[:signals])
    entry[:output]
      .map{|digit| mapping.decode(digit)}
      .join("")
      .to_i
  end

  def parse_input(input='')
    input
      .split("\n")
      .map { |line| line.split(" | ") }
      .map { |signals, output|
        {
          signals: signals.split(" "),
          output: output.split(" ")
        }
      }
  end

  def real_input
    File.read('../inputs/day08-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  INPUT
end

class WireMap

  attr_reader :signals

  def initialize(signals)
    @signals = signals
    @map = nil
  end

  # @example
  #   wire_map = WireMap.new(%w[acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab])
  #   wire_map.decode("acedgfb") #=> 8
  #   wire_map.decode("cdfbe")   #=> 5
  #   wire_map.decode("gcdfa")   #=> 2
  #   wire_map.decode("fbcad")   #=> 3
  #   wire_map.decode("dab")     #=> 7
  #   wire_map.decode("cefabd")  #=> 9
  #   wire_map.decode("cdfgeb")  #=> 6
  #   wire_map.decode("eafb")    #=> 4
  #   wire_map.decode("cagedb")  #=> 0
  #   wire_map.decode("ab")      #=> 1
  def decode(digit)
    map.fetch(digit.chars.sort.join(""))
  end

  def map
    @map ||= map_wires
  end

  # @example
  #   wire_map = WireMap.new(%w[acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab])
  #   wire_map.map_wires #=> {"ab"=>1, "abd"=>7, "abef"=>4, "abcdefg"=>8, "abcdef"=>9, "abcdeg"=>0, "bcdefg"=>6, "bcdef"=>5, "abcdf"=>3, "acdfg"=>2}
  def map_wires
    decoded = {}

    signal_chars = signals.map(&:chars)

    decoded[1] = signal_chars.select{|s| s.length == 2}.first
    signal_chars.delete(decoded[1])

    decoded[7] = signal_chars.select{|s| s.length == 3}.first
    signal_chars.delete(decoded[7])

    decoded[4] = signal_chars.select{|s| s.length == 4}.first
    signal_chars.delete(decoded[4])

    decoded[8] = signal_chars.select{|s| s.length == 7}.first
    signal_chars.delete(decoded[8])

    aaaa = decoded[7] - decoded[1]
    bbbb_dddd = decoded[4] - decoded[1]

    decoded[9] = signal_chars
      .select{|s| s.length == 6 }
      .select{|s| (s & (decoded[7] + bbbb_dddd)).length == 5 }
      .first
    signal_chars.delete(decoded[9])

    gggg = decoded[9] - (decoded[7] + bbbb_dddd)

    decoded[0] = signal_chars
      .select{|s| s.length == 6 }
      .select {|s| ((decoded[8] - s) & decoded[1]).length == 0 }
      .first
    signal_chars.delete(decoded[0])

    decoded[6] = signal_chars.select{|s| s.length == 6 }.first
    signal_chars.delete(decoded[6])

    decoded[5] = signal_chars
      .select {|s| (decoded[6] - s).length == 1 }
      .first
    signal_chars.delete(decoded[5])

    eeee = decoded[6] - decoded[5]

    decoded[3] = signal_chars
      .select{|s| (s & decoded[7]).length == 3 }
      .first
    signal_chars.delete(decoded[3])

    decoded[2] = signal_chars.first

    decoded
      .map{ |digit, signal|
        [signal.sort.join(""), digit]
      }
      .to_h
  end
end
