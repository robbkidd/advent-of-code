require_relative 'day'

class Day08 < Day # >

  # @example
  #   day.part1 #=> 2
  # @example with cycles
  #   day = Day08.new(SIX_STEPS_INPUT)
  #   day.part1 #=> 6
  def part1
    instructions, network = parse(input)
    steps = 0
    current_node = "AAA"
    instructions
      .cycle do |instruction|
        break if current_node == "ZZZ"
        steps += 1
        current_node = network[current_node][instruction]
      end
    steps
  end

  # @example
  #   day = Day08.new(PART2_EXAMPLE_INPUT)
  #   day.part2 #=> 6
  def part2
    instructions, network = parse(input)
    steps = 0
    start_nodes = network.keys.select { |node| node[-1] == "A" }

    start_nodes
      .map { |current_node|
        Thread.new { # for whatever multitasking Ruby will give me
          steps = 0
          a_to_z = nil

          instructions
            .cycle do |instruction|
              if current_node[-1] == "Z"         # on a Z node
                !a_to_z ? a_to_z = steps : break # note how many steps to the first Z node, stop on second Z node
              end

              steps += 1
              current_node = network[current_node][instruction]
            end

          if (steps - a_to_z) != a_to_z
            raise("steps from Z-to-Z must match A-to-Z to use least common multiple")
          end
          a_to_z
        }
      }
      .map(&:value)
      .reduce(1, :lcm)
  end

  # @example
  #   instructions, network = day.parse(EXAMPLE_INPUT)
  #   instructions    #=> ["R", "L"]
  #   network["AAA"]  #=> {"L" => "BBB", "R" => "CCC"}
  def parse(input)
    @stanzas ||= input.split("\n\n")

    @parsed ||=
      [
        @stanzas[0].chars,
        @stanzas[1]
          .each_line
          .map { |line| line.scan(/\w+/) }
          .each_with_object({}) { |(node, left, right), network|
            network[node] = { "L" => left, "R" => right }
          }
      ]
  end

  EXAMPLE_INPUT = <<~INPUT
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
  INPUT

  SIX_STEPS_INPUT = <<~INPUT
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
  INPUT

  PART2_EXAMPLE_INPUT = <<~INPUT
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
  INPUT
end
