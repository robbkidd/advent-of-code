class Intcode
  attr_reader :name, :idx, :program, :debug, :states
  attr_accessor :memory, :input, :output, :relative_base

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
      #output: @output.dup,
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
    @orig_params = []
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
                                               (PARAMETER_MODE_MAP[mode_digit].to_s + "_location").to_sym
                                             else
                                               PARAMETER_MODE_MAP[mode_digit]
                                             end
                                           end
  end

  def parsed_instruction
    @parsed_instruction ||= @raw_instruction.to_s.rjust(5, "0").chars
  end

  def execute(state, params)
    @orig_params = params
    @moded_params = apply_modes(state, params)
    result = @instruction.go.call(state, *@moded_params)
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
      when :position_location
        param
      when :relative
        state.memory.fetch(param + state.relative_base, 0)
      when :relative_location
        param + state.relative_base
      when :immediate
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
      orig_params: @orig_params,
      moded_params: @moded_params,
    }
  end

  def to_s
    to_h.to_s
  end
end
