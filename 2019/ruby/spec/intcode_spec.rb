require 'rspec'
require_relative '../lib/intcode'

describe Intcode do
  context 'Day2 - OP 1,2,99', :day02 => true do
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

  context 'Day5', :day05 => true do
    context 'part 1 - OP 3,4 & new immediate parameter mode' do
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
    end

    context 'part 2 - OP 5,6,7,8' do
      context 'jumping' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9] }
          it 'outputs 0 if input was zero' do
            computer.receive_input 0
            computer.run
            expect(computer.output).to eq([0])
          end
          it 'outputs 1 if input was non-zero' do
            computer.receive_input '99'
            computer.run
            expect(computer.output).to eq([1])
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1] }
          it 'outputs 0 if input was zero' do
            computer.receive_input '0'
            computer.run
            expect(computer.output).to eq([0])
          end
          it 'outputs 1 if input was non-zero' do
            computer.receive_input '99'
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
              computer.receive_input input
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
            computer.receive_input '8'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.receive_input '4'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1108,-1,8,3,4,3,99] }
          it 'outputs 1 if true' do
            computer.receive_input '8'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.receive_input '4'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
      end

      context 'input less than 8?' do
        context 'with a position mode program' do
          let(:computer) { Intcode.new program: [3,9,7,9,10,9,4,9,99,-1,8] }
          it 'outputs 1 if true' do
            computer.receive_input '4'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.receive_input  '9'
            computer.run
            expect(computer.output).to eq([0])
          end
        end

        context 'with an immediate mode program' do
          let(:computer) { Intcode.new program: [3,3,1107,-1,8,3,4,3,99] }
          it 'outputs 1 if true' do
            computer.receive_input '4'
            computer.run
            expect(computer.output).to eq([1])
          end
          it 'outputs 0 if false' do
            computer.receive_input '9'
            computer.run
            expect(computer.output).to eq([0])
          end
        end
      end
    end
  end

  context 'Day9 - OP 9 & new relative parameter mode', :day09 => true do
    context 'example one' do
      let(:program) { [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99] }
      let(:computer) { Intcode.new(program: program, input: []) }

      it 'outputs itself' do
        computer.run
        expect(computer.output).to eq(program)
      end
    end

    context 'example two' do
      let(:program) { [1102,34915192,34915192,7,4,7,99,0] }
      let(:computer) { Intcode.new(program: program, input: []) }

      it 'outputs a 16-digit number' do
        computer.run
        expect(computer.output.first.to_s.length).to eq(16)
      end
    end

    context 'example three' do
      let(:program) { [104,1125899906842624,99] }
      let(:computer) { Intcode.new(program: program, input: []) }

      it 'outputs the big number in the middle' do
        computer.run
        expect(computer.output.first).to eq(program[1])
      end
    end
  end
end
