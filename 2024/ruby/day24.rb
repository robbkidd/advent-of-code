require_relative 'day'

class Day24 < Day # >

  # @example
  #   day.part1 #=> 4
  # @example larger
  #   day = Day24.new(EXAMPLE_LARGER)
  #   day.part1 #=> 2024
  def part1
    known_wires = {}
    to_be_determined = {}
    input
      .split("\n")
      .each do |line|
        case line
        when /\: /
          wire, signal = line.split(": ")
          known_wires[wire] = signal.to_i
        when /-\>/
          input1, gate, input2, wire = line.scan(/\w+/)
          to_be_determined[wire] = { inputs: [input1, input2], gate: gate }
        end
      end

    while to_be_determined.keys.any? {|wire| wire.start_with?('z') } do
      puts to_be_determined.keys.inspect if ENV['DEBUG']
      to_be_determined
        .select {|wire, data| data[:inputs].all? {|input| known_wires.keys.include?(input) } }
        .each do |wire, data|
          known_wires[wire] =
            case data[:gate]
            when 'AND' ; known_wires[data[:inputs][0]] & known_wires[data[:inputs][1]]
            when 'OR'  ; known_wires[data[:inputs][0]] | known_wires[data[:inputs][1]]
            when 'XOR' ; known_wires[data[:inputs][0]] ^ known_wires[data[:inputs][1]]
            else ; raise "lolwut: unknown gate #{data[:gate]}"
            end
          to_be_determined.delete(wire)
        end
    end

    known_wires
      .select {|wire, signal| wire.start_with?('z') }
      .sort_by {|wire, signal| wire }
      .reverse
      .map {|wire, signal| signal.to_s }
      .join
      .to_i(2)
  end

  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day24-example-input.txt")
  EXAMPLE_LARGER = <<~LARGER
    x00: 1
    x01: 0
    x02: 1
    x03: 1
    x04: 0
    y00: 1
    y01: 1
    y02: 1
    y03: 1
    y04: 1

    ntg XOR fgs -> mjb
    y02 OR x01 -> tnw
    kwq OR kpj -> z05
    x00 OR x03 -> fst
    tgd XOR rvg -> z01
    vdt OR tnw -> bfw
    bfw AND frj -> z10
    ffh OR nrd -> bqk
    y00 AND y03 -> djm
    y03 OR y00 -> psh
    bqk OR frj -> z08
    tnw OR fst -> frj
    gnj AND tgd -> z11
    bfw XOR mjb -> z00
    x03 OR x00 -> vdt
    gnj AND wpb -> z02
    x04 AND y00 -> kjc
    djm OR pbm -> qhw
    nrd AND vdt -> hwm
    kjc AND fst -> rvg
    y04 OR y02 -> fgs
    y01 AND x02 -> pbm
    ntg OR kjc -> kwq
    psh XOR fgs -> tgd
    qhw XOR tgd -> z09
    pbm OR djm -> kpj
    x03 XOR y03 -> ffh
    x00 XOR y04 -> ntg
    bfw OR bqk -> z06
    nrd XOR fgs -> wpb
    frj XOR qhw -> z04
    bqk OR frj -> z07
    y03 OR x01 -> nrd
    hwm AND bqk -> z03
    tgd XOR rvg -> z12
    tnw OR pbm -> gnj
  LARGER
end