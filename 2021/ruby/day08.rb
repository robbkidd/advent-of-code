class Day08
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @signals_and_outputs = parse_input(input || real_input)
  end

  # @example
  #   d = Day08.new(EXAMPLE_INPUT)
  #   d.part1 #=> 26
  def part1
    @signals_and_outputs
      .map { |entry|
        entry[:output]
          .filter { |segments| [2, 3, 4, 7].include?(segments.length) }
      }
      .flatten
      .count
  end

  def part2
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
