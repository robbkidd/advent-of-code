### Not My Solution ###
#
# much shorter and simpler because there are only
# 9 combinations of possible outcomes for a round 
class Day02 < Day

  # @example
  #   day.part1 #=> 15
  def part1
    @input
      .split("\n")
      .map { |line|
        PART1_MAP.fetch(line)
      }
      .reduce(&:+)
  end

  # map lifted wholesale from https://github.com/mfinelli/advent-of-code/blob/af64b2d7082b3616029b8ec680cbcc60e9219403/src/y22d02.rs
  PART1_MAP = {
    "A X" => 4, # rock v. rock (1) / draw (3)
    "A Y" => 8, # rock v. paper (2) / win (6)
    "A Z" => 3, # rock v. scissors (3) / lose (0)
    "B X" => 1, # paper v. rock (1) / lose (0)
    "B Y" => 5, # paper v. paper (2) / draw (3)
    "B Z" => 9, # paper v. scissors (3) / win (6)
    "C X" => 7, # scissors v. rock (1) / win (6)
    "C Y" => 2, # scissors v. paper (2) / lose (0)
    "C Z" => 6, # scissors v. scissors (3) / draw (3)
  }

  # @example
  #   day.part2 #=> 12
  def part2
    @input
      .split("\n")
      .map { |line|
        PART2_MAP.fetch(line)
      }
      .reduce(&:+)
  end

  # map lifted wholesale from https://github.com/mfinelli/advent-of-code/blob/af64b2d7082b3616029b8ec680cbcc60e9219403/src/y22d02.rs
  PART2_MAP = {
    "A X" => 3, # rock v. lose (scissors): 0 + 3 = 3
    "A Y" => 4, # rock v. draw (rock): 3 + 1 = 4
    "A Z" => 8, # rock v. win (paper): 6 + 2 = 8
    "B X" => 1, # paper v. lose (rock): 0 + 1 = 1
    "B Y" => 5, # paper v. draw (paper): 3 + 2 = 5
    "B Z" => 9, # paper v. win (scissors): 6 + 3 = 9
    "C X" => 2, # scissors v. lose (paper): 0 + 2 = 2
    "C Y" => 6, # scissors v. draw (scissors): 3 + 3 = 6
    "C Z" => 7, # scissors v. win (rock): 6 + 1 = 7
  }

  EXAMPLE_INPUT = <<~INPUT
    A Y
    B X
    C Z
  INPUT
end
