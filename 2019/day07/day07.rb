class Day7

  def self.part1
    program = File.read('../day05/day05-input.txt').chomp.split(",").map(&:to_i)
    Intcode.new(program: program).run
  end

  def self.part2
    part1
  end
end

class Intcode
  attr_reader :program, :debug

  def initialize(program: [99], debug: false)
    @program = program
    @debug = debug
  end

  def run
    memory = program.dup
    debug_puts "             -- #{(0..memory.length-1).zip(memory).to_s}"
    pointer = 0
    loop do
      debug_puts "           ---- start pointer: #{pointer}"
      op = Instruction.new(memory[pointer])
      return memory if op.opcode == 99

      params = memory[pointer+1..pointer+op.arity]
      debug_puts "             -- #{op} : #{params.to_s}"

      pointer_action, location = op.go(memory, params)
      case pointer_action
      when :jump
        pointer = location
      when :advance
        pointer += location
      end
      debug_puts "             -- #{(0..memory.length-1).zip(memory).to_s}"
    end
  rescue Instruction::InvalidOpcode => e
    binding.pry
  end

  def debug_puts(msg)
    $stderr.puts msg if @debug
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
    1 => Op.new("add", -> (memory, noun, verb, write_location) { memory[write_location] = noun + verb ; nil } ),
    2 => Op.new("multiply", -> (memory, noun, verb, write_location) { memory[write_location] = noun * verb ; nil } ),
    3 => Op.new("input", -> (memory, write_location) { puts "input: "; memory[write_location] = $stdin.gets.strip.to_i ; nil } ),
    4 => Op.new("output", -> (memory, output) { puts output ; nil } ),
    5 => Op.new("jump-if-true", -> (_memory, jump_flag, jump_to) { jump_flag == 0 ? nil : jump_to } ),
    6 => Op.new("jump-if-false", -> (_memory, jump_flag, jump_to) { jump_flag == 0 ? jump_to : nil } ),
    7 => Op.new("less-than", -> (memory, noun, verb, write_location) { memory[write_location] = noun < verb ? 1 : 0 ; nil } ),
    8 => Op.new("equals", -> (memory, noun, verb, write_location) { memory[write_location] = noun == verb ? 1 : 0 ; nil } ),
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

  def go(memory, params)
    moded_params = apply_modes(memory, params)
    result = @instruction.go.call(memory, *moded_params)
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

  context 'Day5 programs' do
    it 'example one' do
      computer = Intcode.new program: [3,0,4,0,99]
      allow($stdin).to receive(:gets).and_return('42')
      expect(computer.run).to eq([42, 0, 4, 0, 99])
      expect{computer.run}.to output("input: \n42\n").to_stdout
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
            allow($stdin).to receive(:gets).and_return('0')
            expect{computer.run}.to output("input: \n0\n").to_stdout
          end
          it 'outputs 1 if input was non-zero' do
            allow($stdin).to receive(:gets).and_return('99')
            expect{computer.run}.to output("input: \n1\n").to_stdout
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1] }
          it 'outputs 0 if input was zero' do
            allow($stdin).to receive(:gets).and_return('0')
            expect{computer.run}.to output("input: \n0\n").to_stdout
          end
          it 'outputs 1 if input was non-zero' do
            allow($stdin).to receive(:gets).and_return('99')
            expect{computer.run}.to output("input: \n1\n").to_stdout
          end
        end
        context 'with a bigger program' do
          let(:computer) { Intcode.new program: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99] }

          [ ["2", "999"],
            ["8", "1000"],
            ["20", "1001"],
          ].each do |input, output|
            it "outputs #{output} given #{input}" do
              allow($stdin).to receive(:gets).and_return(input)
              expect{computer.run}.to output("input: \n#{output}\n").to_stdout
            end
          end
        end
      end

      context 'input equal to 8?' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,9,8,9,10,9,4,9,99,-1,8] }
          it 'outputs 1 if true' do
            allow($stdin).to receive(:gets).and_return('8')
            expect{computer.run}.to output("input: \n1\n").to_stdout
          end
          it 'outputs 0 if false' do
            allow($stdin).to receive(:gets).and_return('4')
            expect{computer.run}.to output("input: \n0\n").to_stdout
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1108,-1,8,3,4,3,99] }
          it 'outputs 1 if true' do
            allow($stdin).to receive(:gets).and_return('8')
            expect{computer.run}.to output("input: \n1\n").to_stdout
          end
          it 'outputs 0 if false' do
            allow($stdin).to receive(:gets).and_return('4')
            expect{computer.run}.to output("input: \n0\n").to_stdout
          end
        end
      end
      context 'input less than 8?' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,9,7,9,10,9,4,9,99,-1,8] }
          it 'outputs 1 if true' do
            allow($stdin).to receive(:gets).and_return('4')
            expect{computer.run}.to output("input: \n1\n").to_stdout
          end
          it 'outputs 0 if false' do
            allow($stdin).to receive(:gets).and_return('9')
            expect{computer.run}.to output("input: \n0\n").to_stdout
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1107,-1,8,3,4,3,99] }
          it 'outputs 1 if true' do
            allow($stdin).to receive(:gets).and_return('4')
            expect{computer.run}.to output("input: \n1\n").to_stdout
          end
          it 'outputs 0 if false' do
            allow($stdin).to receive(:gets).and_return('9')
            expect{computer.run}.to output("input: \n0\n").to_stdout
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
