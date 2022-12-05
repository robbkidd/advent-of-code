class Day05
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
    @stacks = parse_stacks
    @moves = parse_moves
  end

  # @example
  #   day.part1 => "CMZ"
  def part1
    @moves
      .each { |step|
        step[:quantity].times {
          @stacks[step[:to]].push( @stacks[step[:from]].pop)
        }
      }

    @stacks
      .values
      .map(&:last)
      .join("")
  end

  def part2
  end

  # @example
  #   day.parse_stacks => EXAMPLE_STACK_START
  def parse_stacks
    stacks_input, _ = @input.split("\n\n")

    stacks_input
      .split("\n")
      .reverse
      .map(&:chars)
      .transpose
      .select{ |stack| stack[0] != " " }
      .each_with_object({}) { |stack_in, stacks|
        stack_no = stack_in.shift
        stacks[stack_no] = stack_in.select{|crate| crate != " "}
      }
  end

  # @example
  #   day.parse_moves => EXAMPLE_MOVES
  def parse_moves
    _, moves_input = @input.split("\n\n")
    
    moves_input
      .split("\n")
      .each_with_object([]) { |line, moves|
        line.match(/move (\d+) from (\d+) to (\d+)/) { |matchdata|
          moves << { quantity: matchdata[1].to_i, from: matchdata[2], to: matchdata[3] }
        }
      }
  end

  def real_input
    File.read('../inputs/day05-input.txt')
  end

  EXAMPLE_STACK_START = {
    "1" => %w[Z N],
    "2" => %w[M C D],
    "3" => %w[P],
  }
  EXAMPLE_MOVES = [
    { quantity: 1, from: "2", to: "1" },
    { quantity: 3, from: "1", to: "3" },
    { quantity: 2, from: "2", to: "1" },
    { quantity: 1, from: "1", to: "2" },
  ]
  EXAMPLE_INPUT = <<~INPUT
        [D]    
    [N] [C]    
    [Z] [M] [P]
     1   2   3 
    
    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
  INPUT
end
