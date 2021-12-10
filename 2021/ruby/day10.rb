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
      .filter { |result, _| :corrupted == result }
      .map { |_result, char| CLOSERS[char][:corruption_points] }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 288957
  def part2
    completion_scores = input
      .split("\n")
      .map { |line| analyze_line(line) }
      .filter { |result, _| :incomplete == result }
      .map { |_result, opener_stack|
        opener_stack
          .reverse
          .map{ |opener| OPENERS[opener] }
      }
      .map {|completions| completion_score(completions) }
      .sort

    completion_scores[(completion_scores.length / 2).floor]
  end

  # ~Coffee~ Points are for closers.
  CLOSERS = {
    ')' => {opener: '(', corruption_points: 3, completion_points: 1},
    ']' => {opener: '[', corruption_points: 57, completion_points: 2},
    '}' => {opener: '{', corruption_points: 1197, completion_points: 3},
    '>' => {opener: '<', corruption_points: 25137, completion_points: 4},
  }
  OPENERS = CLOSERS.map{ |closer, h| [h[:opener], closer] }.to_h

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
        if OPENERS.keys.include?(char)
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

  # @example
  #   day.completion_score('}}]])})]'.chars) #=> 288957
  #   day.completion_score(')}>]})'.chars) #=> 5566
  #   day.completion_score('}}>}>))))'.chars) #=> 1480781
  #   day.completion_score(']]}}]}]}>'.chars) #=> 995444
  #   day.completion_score('])}>'.chars) #=> 294
  def completion_score(closers)
    closers.reduce(0) do |total_score, closer|
      (total_score * 5) + CLOSERS.fetch(closer).fetch(:completion_points)
    end
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
