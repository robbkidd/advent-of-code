require_relative 'day'

class Day08 < Day # >

  # @example
  #   day.part1 #=> 2
  def part1
    parse(input)
    steps = 0
    node = "AAA"
    @instructions
      .cycle do |instruction|
        break if node == "ZZZ"
        steps += 1
        node = @network[node][instruction]
      end
    steps
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  # @example
  #   inst, net = day.parse(EXAMPLE_INPUT)
  #   inst #=> ["R", "L"]
  def parse(input)
    stanzas = input.split("\n\n")

    @instructions = stanzas[0].chars

    @network = {}
    stanzas[1]
      .each_line
      .map { |line| line.scan(/\w+/) }
      .each { |node, left, right|
        @network[node] = { "L" => left, "R" => right }
      }

    [@instructions, @network]
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
end
