class Day05 < Day
  def moves
    @moves ||= parse_moves
  end

  # @example
  #   day.part1 #=> "CMZ"
  def part1
    crane = CrateMover9000.new(parse_stacks, moves)
    crane.follow_process
    puts crane.ugly_christmas_sweater
    crane.top_crates
  end

  class CrateMover
    attr_reader :stacks, :steps

    def initialize(stacks, steps)
      @stacks = stacks
      @steps = steps
    end

    def follow_process
      raise NotImplementedError, "You must have your model of CrateMover available to operate the crane."
    end

    def top_crates
      stacks
        .values
        .map(&:last)
        .join("")
    end

    def ugly_christmas_sweater
      highest_height = stacks.values.max_by{|v| v.length}.length
      output = []
      stacks.each {|idx, stack|
        crates = []
        crates << " #{idx} "
        stack.each_with_index { |c, i|
          if i == stack.length-1
            crates << "\e[32m[\e[0m\e[41m\e[1m#{c}\e[0m\e[32m]\e[0m"
          else
            crates << "\e[32m[\e[0m\e[41m\e[0m#{c}\e[0m\e[32m]\e[0m"
          end
        }
        crates += (highest_height - stack.length).times.map{|_| "   "}
        output << crates
        output << Array.new(highest_height+1, " ")
      }
      output
        .transpose
        .reverse
        .map{|level| level.join("")}
        .unshift(["\n"])
        .join("\n")
    end
  end

  class CrateMover9000 < CrateMover
    def follow_process
      steps
        .each { |step|
          step[:quantity].times {
            stacks[step[:to]].push( stacks[step[:from]].pop)
          }
        }
    end
  end

  # @example
  #   day.part2 #=> "MCD"
  def part2
    crane = CrateMover9001.new(parse_stacks, moves)
    crane.follow_process
    puts crane.ugly_christmas_sweater
    crane.top_crates
  end

  class CrateMover9001 < CrateMover
    def follow_process
      steps
        .each { |step|
          stacks[step[:to]] += stacks[step[:from]].pop(step[:quantity])
        }
    end
  end

  # @example
  #   day.parse_stacks #=> EXAMPLE_STACK_START
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
  #   day.parse_moves #=> EXAMPLE_MOVES
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
