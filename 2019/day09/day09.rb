class Day9

  def self.part1
    boost_test = Intcode.new(program: load_boost_program, input: [1])
    boost_test.run
    boost_test.output
  end

  def self.part2
  end

  def self.load_boost_program
    File.read('day09-input.txt').chomp.split(",").map(&:to_i)
  end
end

class AmpCircuit
  attr_reader :amps, :threads, :debug
  def initialize(phase_sequence:, software:, debug: false)
    @debug = debug
    @threads = []

    @software = software
    @phase_sequence = phase_sequence
    @amps = []
    @phase_sequence.each_with_index do |phase, id|
      @amps << Intcode.new(idx: id, program: @software, input: [phase], debug: @debug)
    end
  end

  def run(input=0)
    amps.first.receive_input(input)
    amps.each_with_index do |amp, index|
      amp.run
      debug_puts amp.name + ": " + amp.output.to_s
      next_amp = amps[index+1]
      next_amp.receive_input(amp.output) if next_amp
    end
    amps.last.output.last
  end

  def run_with_feedback(input=0)
    amps.first.receive_input(input)
    amps.each_with_index do |amp, index|
      t = Thread.new { debug_puts "🧵  Starting #{amp.name}"; amp.run }
      t[:amp] = amp
      threads << t.run
    end

    last_out = nil
    leads = threads.map do |t|
      Thread.new do
        next_amp_idx = (t[:amp].idx + 1) % threads.length
        while not t[:amp].halted?
          while t[:amp].output.empty?
            sleep 0.001
          end
          next_amp = threads[next_amp_idx][:amp]
          last_out = t[:amp].output.shift
          if not next_amp.halted?
            debug_puts "🧵  {lead #{t[:amp].name} -> #{next_amp.name}} #{t[:amp].idx} -- #{last_out} -> #{next_amp_idx}"
            next_amp.receive_input(last_out)
          else
            debug_puts "🧵  {lead #{t[:amp].idx} -> 🚀 } #{t[:amp].idx} -- #{last_out} -> 🚀"
          end
        end
      end
    end

    leads.map(&:join)
    last_out
  end

  def debug_puts(msg)
    puts msg if debug
  end
end

class Intcode
  attr_reader :name, :idx, :program, :debug, :status, :states
  attr_accessor :memory, :input, :output, :relative_base

  #State = Struct.new(:status, :memory, :pointer, :op, :params, :input, :output)

  def initialize(idx: 0, program: [99], input: [], debug: false)
    @idx = idx
    @name = ('A'..'Z').to_a[idx]
    @program = program
    @input = input
    @debug = debug

    @memory = program.dup
    @relative_base = 0
    @output = []
    @status = :initializing
    @states = [current_state]
    debug_puts "[#{name}] 🐣  #{input.to_s}"
  end

  def current_state
    { status: @status,
      memory: @memory.dup,
      pointer: @pointer.dup,
      relative_base: @relative_base.dup,
      params: @params.dup,
      input: @input.dup,
      output: @output.dup,
    }
  end

  def run
    pointer = 0
    @status = :starting
    @states << self.current_state
    debug_puts "[#{name}] 🟢"
    loop do
      instruction = Instruction.new(memory[pointer])

      params = memory[pointer+1..pointer+instruction.arity]

      pointer_action, location = instruction.execute(self, params)
      case pointer_action
      when :jump
        pointer = location
      when :advance
        pointer += location
      when :halt
        @status = :halted
        @states << self.current_state
        debug_puts "[#{name}] 🛑"
        return memory
      end
      @status = :running
      @states << self.current_state.merge(instruction: instruction.to_s)
    end
  rescue Instruction::InvalidOpcode => e
    debug ? binding.pry : raise(e)
  end

  def status
    states.last[:status]
  end

  def halted?
    status == :halted
  end

  def read_input
    sleep_iter = 0
    while @input.first.nil?
      sleep_iter += 1
      debug_puts "[#{@name}] is waiting for input ..." if sleep_iter % 1000 == 0
      sleep 0.01
    end
    input = @input.shift
    debug_puts "[#{@name}] 👁  #{input}"
    raise "🎅 HO HO oh no! 💥" if input.nil?
    input
  end

  def receive_input(values)
    debug_puts "[#{@name}] 📨  #{values.inspect}"
    if values.kind_of? Array
      values.each {|v| @input << v }
    else
      @input << values
    end
  end

  def send_output(value)
    debug_puts "[#{@name}] 📬  #{value}"
    @output << value
  end

  def debug_puts(msg)
    puts msg if debug
  end
end

class Instruction
  attr_reader :arity

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
    1 => Op.new(:add, -> (state, noun, verb, write_location) { state.memory[write_location] = noun + verb ; :advance } ),
    2 => Op.new(:multiply, -> (state, noun, verb, write_location) { state.memory[write_location] = noun * verb ; :advance } ),
    3 => Op.new(:input, -> (state, write_location) { state.memory[write_location] = state.read_input.to_i ; :advance } ),
    4 => Op.new(:output, -> (state, output) { state.send_output(output) ; :advance } ),
    5 => Op.new(:jump_if_true, -> (_state, jump_flag, jump_to) { jump_flag == 0 ? :advance : jump_to } ),
    6 => Op.new(:jump_if_false, -> (_state, jump_flag, jump_to) { jump_flag == 0 ? jump_to : :advance } ),
    7 => Op.new(:less_than, -> (state, noun, verb, write_location) { state.memory[write_location] = noun < verb ? 1 : 0 ; :advance } ),
    8 => Op.new(:equals, -> (state, noun, verb, write_location) { state.memory[write_location] = noun == verb ? 1 : 0 ; :advance } ),
    9 => Op.new(:update_relative_base, -> (state, base_offset) { state.relative_base += base_offset ; :advance }),
    99 => Op.new(:halt, ->(_state) { :halt } ),
  }
  VALID_OPCODES = INSTRUCTIONS.keys

  def initialize(raw_instruction)
    @raw_instruction = raw_instruction
    unless VALID_OPCODES.include? opcode
      raise InvalidOpcode, "#{opcode} is not a valid opcode. Valid: #{VALID_OPCODES.join(", ")}. Raw instruction was #{@raw_instruction}."
    end
    @instruction = INSTRUCTIONS[opcode]
    @arity = @instruction.arity
    @moded_params = []
  end

  def opcode
    @opcode ||= parsed_instruction[-2..-1].join.to_i
  end

  PARAMETER_MODE_MAP = {
    "0" => :position,
    "1" => :immediate,
    "2" => :relative
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

  def execute(state, params)
    moded_params = apply_modes(state, params)
    result = @instruction.go.call(state, *moded_params)
    case result
    when :advance
      [:advance, arity + 1]
    when :halt
      [:halt, 0]
    else
      [:jump, result]
    end
  rescue TypeError
    binding.pry
  end

  def apply_modes(state, params)
    params.zip(parameter_modes).map do |param, mode|
      case mode
      when :position
        state.memory.fetch(param, 0)
      when :relative
        state.memory.fetch(param + state.relative_base, 0)
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
  context 'Day9' do
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

  context 'Day7' do
    context 'part 1' do
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

    context 'part 2' do
      it 'example one' do
        amp_circuit = AmpCircuit.new(phase_sequence: [9,8,7,6,5],software: [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5])
        expect(amp_circuit.run_with_feedback(0)).to eq(139629729)
      end
      it 'example two' do
        amp_circuit = AmpCircuit.new(phase_sequence: [9,7,8,5,6],software: [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10])
        expect(amp_circuit.run_with_feedback(0)).to eq(18216)
      end
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
