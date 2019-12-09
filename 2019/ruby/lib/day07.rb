class Day07
  def self.go
    puts "Part1: #{part1}"
    puts "\nPart2: #{part2}"
  end

  def self.part1
    (0..4).to_a.permutation.map do |sequence|
      output_signal = AmpCircuit.new(phase_sequence: sequence,
                                     software: amp_control_software).run
      [sequence, output_signal]
    end.max_by {|sequence, output_signal| output_signal }
  end

  def self.part2
    (5..9).to_a.permutation.map do |sequence|
      output_signal = AmpCircuit.new(phase_sequence: sequence,
                                     software: amp_control_software).run_with_feedback
      print "."
      [sequence, output_signal]
    end.max_by {|sequence, output_signal| output_signal }
  end

  def self.amp_control_software
    File.read('../inputs/day07-input.txt').chomp.split(",").map(&:to_i)
  end
end

class AmpCircuit
  require_relative 'intcode'

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
            debug_puts "🧵  {lead #{t[:amp].name} -> 🚀 } #{t[:amp].idx} -- #{last_out} -> 🚀"
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
