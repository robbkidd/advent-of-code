class Day5

  def self.part1
  end

  def self.part2
  end
end

class Intcode
  def self.run(input)
    memory = input.dup
    pointer = memory.each
    loop do
      op = Instruction.new(pointer.next)
      case op.opcode
      when 1
        noun = pointer.next
        verb = pointer.next
        write_location = pointer.next
        memory[write_location] = memory[noun] + memory[verb]
      when 2
        noun = pointer.next
        verb = pointer.next
        write_location = pointer.next
        memory[write_location] = memory[noun] * memory[verb]
      when 3
        input = pointer.next
        write_location = input
        memory[write_location] = input
      when 4
        output = pointer.next
        puts output
      when 99
        return memory
      end
    end
  end
end

class Instruction
  attr_reader :opcode, :parameter_modes

  VALID_OPCODES = [1,2,3,4,99]

  class InvalidOpcode < StandardError; end

  def initialize(raw_instruction)
    @raw_instruction = raw_instruction
    @opcode, @parameter_modes = parse(@raw_instruction)
  end

  def parse(raw_instruction)
    instruction = raw_instruction.to_s.rjust(5, "0").chars
    op = instruction.pop(2).join.to_i
    unless VALID_OPCODES.include? op
      raise InvalidOpcode, "#{op} is not a valid opcode. Valid: #{VALID_OPCODES.join(", ")}. Raw instruction was #{@raw_instruction}."
    end

    parameter_modes = instruction.reverse.map(&:to_i)
    [op, parameter_modes]
  end

  def flesh_out
    @raw_instruction.to_s.rjust(5, "0")
  end
end

require 'rspec'

describe Intcode do
  context 'Day5 programs' do
    it 'example one' do
      input = [3,0,4,0,99]
      expect(Intcode.run(input)).to eq([0, 0, 4, 0, 99])
      expect{Intcode.run(input)}.to output("0\n").to_stdout
    end

    it 'example two' do
      input = [1002,4,3,4,33]
      expect(Intcode.run(input)).to eq([1002,4,3,4,99])
    end
  end

  context 'can still run Day2 programs' do
    it 'example one' do
      input = [1,0,0,0,99]
      expect(Intcode.run(input)).to eq([2,0,0,0,99])
    end

    it 'example two' do
      input = [2,3,0,3,99]
      expect(Intcode.run(input)).to eq([2,3,0,6,99])
    end

    it 'example three' do
      input = [2,4,4,5,99,0]
      expect(Intcode.run(input)).to eq([2,4,4,5,99,9801])
    end

    it 'example four' do
      input = [1,1,1,4,99,5,6,0,99]
      expect(Intcode.run(input)).to eq([30,1,1,4,2,5,6,0,99])
    end

    context 'Day 2' do
      let(:input) {
        [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,9,27,1,5,27,31,1,9,31,35,1,35,10,39,2,13,39,43,1,43,9,47,1,47,9,51,1,6,51,55,1,13,55,59,1,59,13,63,1,13,63,67,1,6,67,71,1,71,13,75,2,10,75,79,1,13,79,83,1,83,10,87,2,9,87,91,1,6,91,95,1,9,95,99,2,99,10,103,1,103,5,107,2,6,107,111,1,111,6,115,1,9,115,119,1,9,119,123,2,10,123,127,1,127,5,131,2,6,131,135,1,135,5,139,1,9,139,143,2,143,13,147,1,9,147,151,1,151,2,155,1,9,155,0,99,2,0,14,0]
      }

      it 'part 1' do
        error_input = input.dup
        error_input[1, 2] = [12, 2]
        Intcode.run(error_input).first
      end
    end
  end
end

describe Instruction do
  context 'instruction padding' do
    it 'fleshes out a short instruction with zeros' do
      expect(Instruction.new("1").flesh_out).to eq("00001")
      expect(Instruction.new(1).flesh_out).to eq("00001")
      expect(Instruction.new("1002").flesh_out).to eq("01002")
      expect(Instruction.new(1002).flesh_out).to eq("01002")
    end
  end

  context 'parses' do
    it '1002' do
      instruction = Instruction.new(1002)
      expect(instruction.opcode).to eq(2)
      expect(instruction.parameter_modes).to eq([0,1,0])
    end
    it '"10102"' do
      instruction = Instruction.new("10102")
      expect(instruction.opcode).to eq(2)
      expect(instruction.parameter_modes).to eq([1,0,1])
    end
    it '"99"' do
      instruction = Instruction.new("99")
      expect(instruction.opcode).to eq(99)
      expect(instruction.parameter_modes).to eq([0,0,0])
    end
    it '3' do
      instruction = Instruction.new(3)
      expect(instruction.opcode).to eq(3)
      expect(instruction.parameter_modes).to eq([0,0,0])
    end
    it '0' do
      expect{Instruction.new(0)}.to raise_error(Instruction::InvalidOpcode)
    end
  end
end
