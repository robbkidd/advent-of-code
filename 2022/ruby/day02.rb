class Day02 < Day
  
  # @example
  #   day.part1 #=> 15
  def part1
    @input
      .split("\n")
      .map { |line|
        score_round_part1(line)
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 12
  def part2
    @input
      .split("\n")
      .map { |line|
        score_round_part2(line)
      }
      .reduce(&:+)
  end

  # @example
  #   day.score_round_part1('A Y') #=> 8
  # @example
  #   day.score_round_part1('B X') #=> 1
  # @example
  #   day.score_round_part1('C Z') #=> 6
  def score_round_part1(line)
    opp_choice, my_choice = line.split(" ")
    opp_shape = OPPONENT_MAP.fetch(opp_choice)
    my_shape = PART1_MAP.fetch(my_choice)

    outcome = case opp_shape
      when my_shape
        :draw
      when WHAT_LOSES_TO.fetch(my_shape)
        :win
      else
        :lose
      end
    
    SHAPE_SCORES.fetch(my_shape) + OUTCOME_SCORES.fetch(outcome)
  end

  # @example
  #   day.score_round_part2('A Y') #=> 4
  # @example
  #   day.score_round_part2('B X') #=> 1
  # @example
  #   day.score_round_part2('C Z') #=> 7
  def score_round_part2(line)
    opp_choice, round_end = line.split(" ")
    opp_shape = OPPONENT_MAP.fetch(opp_choice)
    target_outcome = PART2_MAP.fetch(round_end)

    my_shape = case target_outcome
      when :draw
        opp_shape
      when :win
        WHAT_DEFEATS.fetch(opp_shape)
      when :lose
        WHAT_LOSES_TO.fetch(opp_shape)
      end 
    
    SHAPE_SCORES.fetch(my_shape) + OUTCOME_SCORES.fetch(target_outcome)
  end

  # the name seems backwards here, but consider:
  #
  #   WHAT_LOSES_TO.fetch(:rock) => :scissors
  #
  # or "What is defeated by rock?" -> "scissors"
  WHAT_LOSES_TO = {
    rock: :scissors,
    scissors: :paper,
    paper: :rock,
  }

  # ... and then we invert it so we can look up the
  # other direction
  WHAT_DEFEATS = WHAT_LOSES_TO.invert

  OPPONENT_MAP = {
    'A' => :rock,
    'B' => :paper,
    'C' => :scissors,
  }

  PART1_MAP = {
    'X' => :rock,
    'Y' => :paper,
    'Z' => :scissors,
  }

  PART2_MAP = {
    'X' => :lose,
    'Y' => :draw,
    'Z' => :win,
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

  EXAMPLE_INPUT = <<~INPUT
    A Y
    B X
    C Z
  INPUT
end
