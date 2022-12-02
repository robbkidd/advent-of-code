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
    
    my_shape.score + OUTCOME_SCORES.fetch(my_shape.against(opp_shape))
  end

  Shape = Struct.new(:name, :score, :defeats) do
    def against(other)
      case other.name
      when name
        return :draw
      when defeats
        return :win 
      else 
        return :lose
      end
    end
  end

  ROCK = Shape.new('rock', 1, 'scissors')
  PAPER = Shape.new('paper', 2, 'rock')
  SCISSORS = Shape.new('scissors', 3, 'paper')

  OPPONENT_MAP = {
    'A' => ROCK,
    'B' => PAPER,
    'C' => SCISSORS,
  }

  MY_MAP = {
    'X' => ROCK,
    'Y' => PAPER,
    'Z' => SCISSORS,
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
