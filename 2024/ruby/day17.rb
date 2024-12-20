require_relative 'day'
require 'parallel'

class Day17 < Day # >

  # @example
  #   day.part1 #=> '4,6,3,5,6,3,5,2,1,0'
  def part1
    computer = ChronospatialComputer.new(input)
    computer.run
    computer.output.join(',')
  end

  # @example
  #   day = new(EXAMPLE_PART2)
  #   day.part2 #=> 117440
  def part2
    quiney_inputs = Thread::Queue.new
    n = 0
    every = 1_000_000
    while quiney_inputs.empty?
      Parallel.map(n..n+every, in_threads: 4, progress: "Trying #{n}..#{n+every}") { |value|
        computer = ChronospatialComputer.new(input)
        computer.registers[:a] = value
        computer.run
        if computer.output == computer.program
          quiney_inputs << value
          raise Parallel::Break
        end
      }
      n += every
    end
    results = []
    results << quiney_inputs.pop until quiney_inputs.empty?
    results.min
  end

  EXAMPLE_INPUT = File.read("../inputs/day17-example-input.txt")
  EXAMPLE_PART2 = <<~EXAMPLE
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
  EXAMPLE
end

class ChronospatialComputer
  attr_reader :input, :registers, :program, :output, :state
  # @example
  #   computer = new(Day17::EXAMPLE_INPUT)
  #   computer.registers #=> {a: 729, b: 0, c: 0}
  #   computer.program   #=> [0,1,5,4,3,0]
  def initialize(input='')
    @input = input
    @registers, @program = parse(input)
    @instruction_pointer = 0
    @output = []
    @state = :initialized
  end

  # @example
  #   computer = new('')
  #   computer.parse(Day17::EXAMPLE_INPUT) #=> [{a: 729,b: 0,c: 0},[0,1,5,4,3,0]]
  def parse(input)
    input_numbers = input.scan(/\d+/).map(&:to_i)
    [
      { a: input_numbers[0], b: input_numbers[1], c: input_numbers[2] },
      input_numbers[3..]
    ]
  end

  OPCODES = {
    0 => :adv,
    1 => :bxl,
    2 => :bst,
    3 => :jnz,
    4 => :bxc,
    5 => :out,
    6 => :bdv,
    7 => :cdv,
  }
  OPCODES.default_proc = ->(h,k){ raise "unknown opcode: #{k}" }

  # @example If register C contains 9, the program 2,6 would set register B to 1.
  #  computer = new('0 0 9 2 6')
  #  computer.run
  #  computer.registers[:b] #=> 1
  #
  # @example If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
  #   computer = new('10 0 0 5 0 5 1 5 4')
  #   computer.run
  #   computer.output #=> [0,1,2]
  #
  # @example If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
  #   computer = new('2024 0 0 0 1 5 4 3 0')
  #   computer.run
  #   computer.output #=> [4,2,5,6,7,7,7,7,3,1,0]
  #   computer.registers[:a] #=> 0
  #
  # @example If register B contains 29, the program 1,7 would set register B to 26.
  #   computer = new('0 29 0 1 7')
  #   computer.run
  #   computer.registers[:b] #=> 26
  #
  # @example If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
  #   computer = new('0 2024 43690 4 0')
  #   computer.run
  #   computer.registers[:b] #=> 44354
  def run
    @state = :running
    while @state != :halted
      if @instruction_pointer < 0 || @instruction_pointer >= @program.length
        @state = :halted
        break
      else
        opcode, operand = @program[@instruction_pointer, 2].tap{ puts _1.inspect if ENV['DEBUG'] }
        send(OPCODES.fetch(opcode), operand)
      end
      puts @output.inspect if ENV['DEBUG']
    end
  end

  def decompile
    @decompiled ||=
      @program.each_slice(2).map{ |opcode, operand|
        "#{OPCODES.fetch(opcode)}(#{operand})"
      }.join("\n")
  end

  def combo_value(combo)
    case combo
    when 0,1,2,3 ; combo
    when 4 ; @registers.fetch(:a)
    when 5 ; @registers.fetch(:b)
    when 6 ; @registers.fetch(:c)
    when 7 ; raise "reserved: should not have appeared in a valid program (...yet?)"
    end
  end

  # @example with low combo (treat as literal)
  #   computer = new('')
  #   computer.registers[:a] = 17
  #   computer.adv(2)
  #   computer.registers[:a] #=> 4
  # @example with high combo (use value in register)
  #   computer = new('')
  #   computer.registers[:a] = 17
  #   computer.registers[:b] = 2
  #   computer.adv(5)
  #   computer.registers[:a] #=> 4
  def adv(combo)
    @registers[:a] = ( @registers.fetch(:a) / 2**combo_value(combo) ).truncate
    @instruction_pointer += 2
  end

  # @example
  #   computer = new
  #   computer.registers[:b] = 1
  #   computer.bxl(2)
  #   computer.registers[:b] #=> 3
  def bxl(literal)
    @registers[:b] = @registers[:b] ^ literal
    @instruction_pointer += 2
  end

  def bst(combo)
    @registers[:b] = combo_value(combo) % 8
    @instruction_pointer += 2
  end

  def jnz(literal)
    if @registers[:a].zero?
      @instruction_pointer += 2
    else
      @instruction_pointer = literal
    end
  end

  def bxc(_ignored)
    @registers[:b] = @registers[:b] ^ @registers[:c]
    @instruction_pointer += 2
  end

  def out(combo)
    @output << combo_value(combo) % 8
    @instruction_pointer += 2
  end

  def bdv(combo)
    @registers[:b] = ( @registers.fetch(:a) / 2**combo_value(combo) ).truncate
    @instruction_pointer += 2
  end

  def cdv(combo)
    @registers[:c] = ( @registers.fetch(:a) / 2**combo_value(combo) ).truncate
    @instruction_pointer += 2
  end
end
