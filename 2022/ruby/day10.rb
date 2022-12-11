require_relative 'day'

class Day10 < Day # >

  # @example
  #   day.part1 #=> 13_140
  def part1
    cpu = CPU.new(input)
    
    [ 20, 60, 100, 140, 180, 220 ]
      .map { |nth| nth * cpu.signal_during_nth_cycle(nth) }
      .reduce(&:+)
  end

  # @example
  #   day.part2 
  def part2
  end

  # It's just too dang long to include in code up here.
  EXAMPLE_INPUT = File.read("day10-example-input.txt")
end

class CPU

  OP_CYCLE_TIME= {
    "noop" => 1,
    "addx" => 2,
  }

  def initialize(input)
    @instructions = parse_input(input).cycle
    @x = 1
    @x_during = [:pad_for_1_based_indexing] # you should never see that symbol
    @cycles = 0
    @doing = nil
    @processing_countdown = 0
  end

  # @example simple input
  #   cpu = new(SMALL_PROGRAM)
  #   (1..5).map { |nth| cpu.signal_during_nth_cycle(nth) } #=> [1, 1, 1, 4, 4]
  #
  # @example example input
  #   cpu = new(Day10::EXAMPLE_INPUT)
  #   [ 20, 60, 100, 140, 180, 220 ]
  #     .map { |nth| cpu.signal_during_nth_cycle(nth) } #=> [21, 19, 18, 21, 16, 18]
  def signal_during_nth_cycle(n)
    if @cycles < n
      (n - @cycles + 1).times { tick }
    end
    @x_during.at(n)
  end

  def tick
    @x_during << @x

    if @processing_countdown == 0
      @doing = @instructions.next
      @processing_countdown = OP_CYCLE_TIME.fetch(@doing[:op])
    end

    @processing_countdown -= 1

    if @processing_countdown == 0
      case @doing[:op]
      when "noop" ; :do_nothing
      when "addx" ; @x += @doing[:value]
      else
        raise NotImplementedError, "Unknown op. What's a #{@doing[:op]}?"
      end
    end

    @cycles += 1
  end

  def parse_input(input)
    case input
    when nil ; []
    when [] ; []
    else
      input
        .split("\n")
        .map{ |line| line.split(" ") }
        .map{ |op,value| { op: op, value: value.to_i } }
    end
  end

  SMALL_PROGRAM = <<~INPUT
    noop
    addx 3
    addx -5
  INPUT
end
