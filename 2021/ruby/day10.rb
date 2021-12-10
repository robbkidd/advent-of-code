class Day10
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example
  #   day.part1 #=> 26397
  def part1
    input
      .split("\n")
      .map { |line| analyze_line(line) }
      .filter { |result, _char| :corrupted == result }
      .map { |_result, char| CLOSERS[char][:corruption_points] }
      .reduce(&:+)
  end

  def part2
  end

  # ~Coffee~ Points are for closers.
  CLOSERS = {
    ')' => {opener: '(', corruption_points: 3},
    ']' => {opener: '[', corruption_points: 57},
    '}' => {opener: '{', corruption_points: 1197},
    '>' => {opener: '<', corruption_points: 25137},
  }
  OPENERS = CLOSERS.values.map{|c| c[:opener]}

  # @example
  #   day.analyze_line('{([(<{}[<>[]}>{[]{[(<()>') #=> [:corrupted, '}']
  #   day.analyze_line('[[<[([]))<([[{}[[()]]]') #=> [:corrupted, ')']
  #   day.analyze_line('[{[{({}]{}}([{[{{{}}([]') #=> [:corrupted, ']']
  #   day.analyze_line('[<(<(<(<{}))><([]([]()') #=> [:corrupted, ')']
  #   day.analyze_line('<{([([[(<>()){}]>(<<{{') #=> [:corrupted, '>']
  def analyze_line(line)
    stack = []
    line
      .chars
      .each do |char|
        if OPENERS.include?(char)
          stack.push(char)
          next
        else
          c = stack.pop
          if CLOSERS[char][:opener] != c
            return [:corrupted, char]
          end
        end
      end
    return stack.empty? ? [:ok, nil] : [:incomplete, stack]
  end

  def real_input
    File.read('../inputs/day10-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
  INPUT
end
