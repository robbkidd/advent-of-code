require_relative 'intcode'

class Day02
  INPUT = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,9,27,1,5,27,31,1,9,31,35,1,35,10,39,2,13,39,43,1,43,9,47,1,47,9,51,1,6,51,55,1,13,55,59,1,59,13,63,1,13,63,67,1,6,67,71,1,71,13,75,2,10,75,79,1,13,79,83,1,83,10,87,2,9,87,91,1,6,91,95,1,9,95,99,2,99,10,103,1,103,5,107,2,6,107,111,1,111,6,115,1,9,115,119,1,9,119,123,2,10,123,127,1,127,5,131,2,6,131,135,1,135,5,139,1,9,139,143,2,143,13,147,1,9,147,151,1,151,2,155,1,9,155,0,99,2,0,14,0]

  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    error_input = INPUT.dup
    error_input[1, 2] = [12, 2]
    Intcode.run(error_input).first
  end

  def self.part2
    (0..99).each do |noun_in|
      (0..99).each do |verb_in|
        try = INPUT.dup
        try[1, 2] = [noun_in, verb_in]
        result = Intcode.run(try).first

        next unless result == 19690720

        correct_inputs = 100 * noun_in + verb_in
        return "These worked: #{noun_in}, #{verb_in}. So it's #{correct_inputs}."
      end
    end
    "Nope. If you're seeing this, something has gone horribly wrong."
  end
end

class Intcode
  VALID_OPCODES = [1,2,99]
  def self.run(input)
    memory = input.dup
    (0..memory.length).step(4).each do |instruction_pointer|
      opcode = memory[instruction_pointer]
      return memory if opcode == 99
      raise "Waaat?" unless VALID_OPCODES.include?(opcode)

      noun = memory[instruction_pointer+1]
      verb = memory[instruction_pointer+2]
      input1 = memory[noun]
      input2 = memory[verb]
      write_location = memory[instruction_pointer+3]

      case opcode
      when 1
        memory[write_location] = input1 + input2
      when 2
        memory[write_location] = input1 * input2
      end
    end
  end
end

require 'rspec'

describe Intcode do
  context 'part1' do
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
  end
end
