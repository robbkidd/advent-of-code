class Day7

  def self.part1
    (0..4).to_a.permutation.map do |sequence|
      output_signal = AmpCircuit.new(phase_sequence: sequence,
                                     software: amp_control_software).run
      [sequence, output_signal]
    end.max_by {|sequence, output_signal| output_signal }
  end

  def self.part2
  end

  def self.amp_control_software
    File.read('day07-input.txt').chomp.split(",").map(&:to_i)
  end
end

class AmpCircuit
  attr_reader :amps
  def initialize(phase_sequence:, software:)
    @phase_sequence = phase_sequence
    @software = software
    @amps = @phase_sequence.map{ |phase| Intcode.new(program: @software, input: [phase]) }
  end

  def run(input=0)
    amps.first.provide_input([input])
    amps.each_with_index do |amp, index|
      amp.run
      next_amp = amps[index+1]
      next_amp.provide_input(amp.output) if next_amp
    end
    amps.last.output.first
  end
end

class Intcode
  attr_reader :program, :debug, :states
  attr_accessor :memory, :input, :output

  def initialize(program: [99], input: [], debug: false)
    @program = program
    @input = input
    @debug = debug

    @memory = program.dup
    @output = []
    @states = []
  end

  ComputerState = Struct.new(:memory, :pointer, :op, :params, :input)

  def run
    pointer = 0
    @states << ComputerState.new(memory.dup, pointer, nil, nil, input.dup)
    loop do
      op = Instruction.new(memory[pointer])
      return memory if op.opcode == 99

      params = memory[pointer+1..pointer+op.arity]

      pointer_action, location = op.go(self, params)
      case pointer_action
      when :jump
        pointer = location
      when :advance
        pointer += location
      end
      @states << ComputerState.new(memory.dup, pointer, op, params, input.dup)
    end
  rescue Instruction::InvalidOpcode => e
    debug ? binding.pry : raise(e)
  end

  def eat_input
    @input.shift
  end

  def provide_input(values)
    if values.kind_of? Array
      @input += values
    else
      @input << values
    end
  end
end

class Instruction
  attr_reader :opcode, :parameter_modes, :arity

  class InvalidOpcode < StandardError; end

  Op = Struct.new(:name, :go) do
    def arity
      go.parameters.length - 1
    end

    def location_params_mask
      go.parameters.map do |_, param_sym|
        param_sym.to_s.end_with?("_location")
      end[1..]
    end
  end

  INSTRUCTIONS = {
    1 => Op.new("add", -> (state, noun, verb, write_location) { state.memory[write_location] = noun + verb ; nil } ),
    2 => Op.new("multiply", -> (state, noun, verb, write_location) { state.memory[write_location] = noun * verb ; nil } ),
    3 => Op.new("input", -> (state, write_location) { state.memory[write_location] = state.eat_input.to_i ; nil } ),
    4 => Op.new("output", -> (state, output) { state.output << output ; nil } ),
    5 => Op.new("jump-if-true", -> (_state, jump_flag, jump_to) { jump_flag == 0 ? nil : jump_to } ),
    6 => Op.new("jump-if-false", -> (_state, jump_flag, jump_to) { jump_flag == 0 ? jump_to : nil } ),
    7 => Op.new("less-than", -> (state, noun, verb, write_location) { state.memory[write_location] = noun < verb ? 1 : 0 ; nil } ),
    8 => Op.new("equals", -> (state, noun, verb, write_location) { state.memory[write_location] = noun == verb ? 1 : 0 ; nil } ),
    99 => Op.new("end", ->(){} ),
  }
  VALID_OPCODES = INSTRUCTIONS.keys

  def initialize(raw_instruction)
    @raw_instruction = raw_instruction
    unless VALID_OPCODES.include? opcode
      raise InvalidOpcode, "#{opcode} is not a valid opcode. Valid: #{VALID_OPCODES.join(", ")}. Raw instruction was #{@raw_instruction}."
    end
    @instruction = INSTRUCTIONS[opcode]
    @arity = @instruction.arity
  end

  def opcode
    @opcode ||= parsed_instruction[-2..-1].join.to_i
  end

  PARAMETER_MODE_MAP = {
    "0" => :position,
    "1" => :immediate,
  }

  def parameter_modes
    @parameter_modes ||= parsed_instruction.take(3)
                                           .reverse
                                           .zip(@instruction.location_params_mask)
                                           .map do |mode_digit, location_param|
                                             if location_param
                                               :location
                                             else
                                               PARAMETER_MODE_MAP[mode_digit]
                                             end
                                           end
  end

  def parsed_instruction
    @parsed_instruction ||= @raw_instruction.to_s.rjust(5, "0").chars
  end

  def go(state, params)
    moded_params = apply_modes(state.memory, params)
    result = @instruction.go.call(state, *moded_params)
    if result
      [:jump, result]
    else
      [:advance, arity + 1]
    end
  rescue TypeError => e
    binding.pry
  end

  def apply_modes(memory, params)
    params.zip(parameter_modes).map do |param, mode|
      case mode
      when :position
        memory[param]
      when :immediate, :location
        param
      else
        raise "What kind of weird mode are you in?"
      end
    end
  end

  def to_h
    { raw_instruction: @raw_instruction,
      opcode: opcode,
      name: @instruction.name,
      parameter_modes: parameter_modes,
    }
  end

  def to_s
    to_h.to_s
  end
end

require 'rspec'

describe Intcode do
  context 'new' do
    it 'has some defaults' do
      expect(subject.program).to eq([99])
      expect(subject.debug).to be false
    end
  end

  context 'Day7' do
    it 'example one' do
      amp_circuit = AmpCircuit.new(
        phase_sequence: [4,3,2,1,0],
        software: [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
      )
      expect(amp_circuit.run(0)).to eq(43210)
    end
    it 'example two' do
      amp_circuit = AmpCircuit.new(
        phase_sequence: [0,1,2,3,4],
        software: [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
      )
      expect(amp_circuit.run(0)).to eq(54321)
    end
    it 'example three' do
      amp_circuit = AmpCircuit.new(
        phase_sequence: [1,0,4,3,2],
        software: [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
      )
      expect(amp_circuit.run(0)).to eq(65210)
    end
  end

  context 'Day5 programs' do
    context 'example one' do
      let(:computer) { Intcode.new(program: [3,0,4,0,99], input: [42]) }
      it 'has expected end state' do
        expect(computer.run).to eq([42, 0, 4, 0, 99])
      end
      it 'outputs what was input' do
        computer.run
        expect(computer.output).to eq([42])
      end
    end

    it 'example two' do
      computer = Intcode.new program: [1002,4,3,4,33]
      expect(computer.run).to eq([1002,4,3,4,99])
    end

    context 'part 2 examples' do
      context 'jumping' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9] }
          it 'outputs 0 if input was zero' do
            computer.input << 0
            computer.run
            expect(computer.output).to eq([0])
          end
          it 'outputs 1 if input was non-zero' do
            computer.input << '99'
            computer.run
            expect(computer.output).to eq([1])
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1] }
          it 'outputs 0 if input was zero' do
            computer.input << '0'
            computer.run
            expect(computer.output).to eq([0])
          end
          it 'outputs 1 if input was non-zero' do
            computer.input << '99'
            computer.run
            expect(computer.output).to eq([1])
          end
        end
        context 'with a bigger program' do
          let(:computer) { Intcode.new program: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99] }

          [ ["2", 999],
            ["8", 1000],
            ["20", 1001],
          ].each do |input, output|
            it "outputs #{output} given #{input}" do
              computer.input << input
              computer.run
              expect(computer.output).to eq([output])
            end
          end
        end
      end

      context 'input equal to 8?' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,9,8,9,10,9,4,9,99,-1,8] }
          it 'outputs 1 if true' do
            computer.input << '8'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.input << '4'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1108,-1,8,3,4,3,99] }
          it 'outputs 1 if true' do
            computer.input << '8'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.input << '4'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
      end
      context 'input less than 8?' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,9,7,9,10,9,4,9,99,-1,8] }
          it 'outputs 1 if true' do
            computer.input << '4'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.input << '9'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1107,-1,8,3,4,3,99] }
          it 'outputs 1 if true' do
            computer.input << '4'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.input << '9'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
      end
    end
  end

  context 'can still run Day2 programs' do
    [ { program: [1,0,0,0,99], end_state: [2,0,0,0,99] },
      { program: [2,3,0,3,99], end_state: [2,3,0,6,99] },
      { program: [2,4,4,5,99,0], end_state: [2,4,4,5,99,9801] },
      { program: [1,1,1,4,99,5,6,0,99], end_state: [30,1,1,4,2,5,6,0,99] },
    ].each do |example|

      it example[:program].to_s do
        computer = Intcode.new(program: example[:program])
        expect(computer.run).to eq(example[:end_state])
      end
    end

    it 'Day 2 - part 1' do
      program = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,9,27,1,5,27,31,1,9,31,35,1,35,10,39,2,13,39,43,1,43,9,47,1,47,9,51,1,6,51,55,1,13,55,59,1,59,13,63,1,13,63,67,1,6,67,71,1,71,13,75,2,10,75,79,1,13,79,83,1,83,10,87,2,9,87,91,1,6,91,95,1,9,95,99,2,99,10,103,1,103,5,107,2,6,107,111,1,111,6,115,1,9,115,119,1,9,119,123,2,10,123,127,1,127,5,131,2,6,131,135,1,135,5,139,1,9,139,143,2,143,13,147,1,9,147,151,1,151,2,155,1,9,155,0,99,2,0,14,0]
      error_input = program.dup
      error_input[1, 2] = [12, 2]
      computer = Intcode.new(program: error_input)
      computer.run.first
    end
  end
end
