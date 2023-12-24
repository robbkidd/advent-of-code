require_relative 'day'

class Day20 < Day # >

  # @example
  #   day = Day20.new(EXAMPLE_INPUT)
  #   day.part1 #=> 32_000_000
  # @example more_interesting
  #   day = Day20.new(MORE_INTERESTING_EXAMPLE_INPUT)
  #   day.part1 #=> 11_687_500
  def part1
    PulsePropagation
      .new(input)
      .push_the_button(1_000)[:counts]
      .values
      .reduce(&:*)
  end

  # example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
  INPUT

  EXAMPLE_ONE_PUSH = <<~OUTPUT
    button -low-> broadcaster
    broadcaster -low-> a
    broadcaster -low-> b
    broadcaster -low-> c
    a -high-> b
    b -high-> c
    c -high-> inv
    inv -low-> a
    a -low-> b
    b -low-> c
    c -low-> inv
    inv -high-> a
  OUTPUT

  MORE_INTERESTING_EXAMPLE_INPUT = <<~INPUT
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
  INPUT

  MORE_INTERESTING_ONE_PUSH = <<~OUTPUT
    button -low-> broadcaster
    broadcaster -low-> a
    a -high-> inv
    a -high-> con
    inv -low-> b
    con -high-> output
    b -high-> con
    con -low-> output
  OUTPUT
end

class PulsePropagation
  attr_reader :modules
  attr_accessor :debug

  def initialize(input)
    @modules = {}
    parse(input)
    init_conjunction_inputs
  end

  def parse(input)
    input
      .split("\n")
      .map {|line| line.split(" -> ")}
      .each do |module_name, destinations|
        destination_modules = destinations.split(", ")
        case module_name
        when "broadcaster"
          @modules["broadcaster"] = Broadcaster.new(destination_modules)
        when /\A\%(.*)\z/
          @modules[$1] = FlipFlop.new($1, destination_modules)
        when /\A\&(.*)\z/
          @modules[$1] = Conjunction.new($1, destination_modules)
        end
      end
  end

  def init_conjunction_inputs
    modules
      .each do |sender_name, mod|
        mod.destinations
          .each do |dest_name|
            if modules[dest_name] && modules[dest_name].is_a?(Conjunction)
              modules[dest_name].most_recent_pulse[sender_name] = :low
            end
          end
      end
  end

  # @example first_example
  #   p = PulsePropagation.new(Day20::EXAMPLE_INPUT)
  #   p.debug = true
  #   p.push_the_button(1)[:pulses].join("\n")+"\n" #=> Day20::EXAMPLE_ONE_PUSH
  # @example more_interesting
  #   p = PulsePropagation.new(Day20::MORE_INTERESTING_EXAMPLE_INPUT)
  #   p.debug = true
  #   p.push_the_button(1)[:pulses].join("\n")+"\n" #=> Day20::MORE_INTERESTING_ONE_PUSH
  def push_the_button(push_count=1)
    button = Button.new
    wiretap = {counts: {low: 0, high: 0}, pulses: []}

    push_count.times do
      queue = []
      button.push(queue)
      while message = queue.shift do
        wiretap[:counts][message[:pulse]] += 1
        wiretap[:pulses] << trace_message(message) if debug

        receiver = @modules[message[:destination]]
        if receiver
          receiver.receive(message[:sender], message[:pulse], queue)
        end
      end
    end

    wiretap
  end

  def trace_message(message)
    "#{message[:sender]} -#{message[:pulse]}-> #{message[:destination]}"
  end


  class Modyule
    attr_reader :name, :destinations

    def initialize(name, destination_modules)
      @name = name
      @destinations = destination_modules
    end

    def receive(_sender, _pulse, _queue)
      raise NotImplementedError.new("You must implement #{name} with a signature (sender, pulse, queue).")
    end

    def send(pulse, queue)
      destinations
        .each do |destination|
          queue << {sender: name, destination: destination, pulse: pulse}
        end
    end
  end

  # there is a module with a single button on it called, aptly, the button module.
  # When you push the button, a single low pulse is sent directly to the broadcaster module.
  class Button < Modyule
    def initialize
      super("button", ["broadcaster"])
    end

    def push(queue)
      send(:low, queue)
    end
  end

  # There is a single broadcast module (named broadcaster).
  # When it receives a pulse, it sends the same pulse to all of its destination modules.
  class Broadcaster < Modyule
    def initialize(destination_modules)
      super("broadcaster", destination_modules)
    end

    def receive(_sender, pulse, queue)
      send(pulse, queue)
    end
  end

  # Flip-flop modules (prefix %) are either on or off; they are initially off.
  class FlipFlop < Modyule
    def initialize(name, destination_modules)
      super(name, destination_modules)
      @state = :off
    end

    def receive(_sender, pulse, queue)
      # If a flip-flop module receives a high pulse, it is ignored and nothing happens.
      return if pulse == :high
      raise("pulse should be :high or :low. what the heck is #{pulse.inspect}?") unless pulse == :low

      # However, if a flip-flop module receives a low pulse, it flips between on and off.
      # If it was off, it turns on and sends a high pulse.
      if @state == :off
        @state = :on
        send_pulse = :high
      else
      # If it was on, it turns off and sends a low pulse.
        @state = :off
        send_pulse = :low
      end

      send(send_pulse, queue)
    end
  end

  # Conjunction modules (prefix &) remember the type of the most recent pulse received
  # from each of their connected input modules; they initially default to remembering
  # a low pulse for each input. When a pulse is received, the conjunction module first
  # updates its memory for that input. Then, if it remembers high pulses for all inputs,
  # it sends a low pulse; otherwise, it sends a high pulse.
  class Conjunction < Modyule
    attr_reader :most_recent_pulse

    def initialize(name, destination_modules)
      super(name, destination_modules)
      @most_recent_pulse = Hash.new
    end

    def receive(sender, pulse, queue)
      @most_recent_pulse[sender] = pulse

      send_pulse = @most_recent_pulse.values.all?(:high) ? :low : :high

      send(send_pulse, queue)
    end
  end
end
