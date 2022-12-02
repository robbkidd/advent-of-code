class Day02
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example
  #   day.part1 #=> 15
  def part1
    @input
      .split("\n")
      .map { |line|
        score_round(line)
      }
      .reduce(&:+)
  end

  def part2
  end

  # @example
  #   day.score_round('A Y') #=> 8
  def score_round(line)
    opp_choice, my_choice = line.split(" ")
    opp_shape = OPPONENT_MAP.fetch(opp_choice)
    my_shape = MY_MAP.fetch(my_choice)
    
    SHAPE_SCORES.fetch(my_shape) + OUTCOME_SCORES.fetch(against(opp_shape, my_shape))
  end

  def against(opp_shape, my_shape)
    return :draw if opp_shape == my_shape
    return :win if opp_shape == DEFEATS.fetch(my_shape)
    return :lose
  end

  DEFEATS = {
    rock: :scissors,
    scissors: :paper,
    paper: :rock,
  }

  DEFEATED_BY = DEFEATS.invert

  OPPONENT_MAP = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors,
  }

  MY_MAP = {
    'X' => :rock,
    'Y' => :paper,
    'Z' => :scissors,
  }

  SHAPE_SCORES = {
    rock: 1,
    paper: 2,
    scissors: 3,
  }

  OUTCOME_SCORES = {
    lose: 0,
    draw: 3,
    win: 6,
  }

  def real_input
    File.read('../inputs/day02-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    A Y
    B X
    C Z
  INPUT
end
