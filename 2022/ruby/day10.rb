require_relative 'day'

class Day10 < Day # >

  def initialize(*)
    super
    @cpu = CPU.new(input)
  end

  # @example
  #   day.part1 #=> 13_140
  def part1
    [ 20, 60, 100, 140, 180, 220 ]
      .map { |nth|
        nth * @cpu.x_during_nth_cycle(nth)
      }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> PART2_EXAMPLE_OUTPUT
  def part2
    crt = CRT.new(@cpu)
    if input == EXAMPLE_INPUT
      crt.refresh_screen
    else
      ugly_christmas_sweater("\n" + crt.refresh_screen)
    end
  end

  def a_little_extra(snooze=0.05)
    Signal.trap("INT") {
      puts "\nInterrupt! Disconnected."
      exit
    }

    crt = CRT.new( CPU.new( input ) )
    STDOUT.sync = true
    (CRT::WIDTH.count * CRT::HEIGHT.count).times {
      crt.tick
      puts ugly_christmas_sweater(crt.diag)
      sleep(snooze)
    }
    STDOUT.sync = false
  end

  # It's just too dang long to include in code up here.
  EXAMPLE_INPUT = File.read("day10-example-input.txt")

  PART2_EXAMPLE_OUTPUT = <<~OUTPUT
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######.....
  OUTPUT
end

class CPU

  OP_CYCLE_TIME= {
    "noop" => 1,
    "addx" => 2,
  }

  def initialize(input=nil)
    @instructions = parse_input(input).cycle
    @x = 1
    @x_during = [:pad_for_1_based_indexing] # you should never see that symbol
    @cycles = 0
    @doing = nil
    @processing_countdown = 0
  end

  # @example simple input
  #   cpu = new(SMALL_PROGRAM)
  #   (1..5).map { |nth| cpu.x_during_nth_cycle(nth) } #=> [1, 1, 1, 4, 4]
  #
  # @example example input
  #   cpu = new(Day10::EXAMPLE_INPUT)
  #   [ 20, 60, 100, 140, 180, 220 ]
  #     .map { |nth| cpu.x_during_nth_cycle(nth) } #=> [21, 19, 18, 21, 16, 18]
  def x_during_nth_cycle(n)
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

class CRT
  WIDTH = (0..39)
  HEIGHT = (0..5)

  LIT_PIXEL = "#".freeze
  DARK_PIXEL = ".".freeze
  NOT_DRAWN = " ".freeze

  def initialize(cpu=nil)
    @cpu = cpu || CPU.new([])
    @cycles = 0
    @screen = Hash.new(NOT_DRAWN)
  end

  def refresh_screen
    tick( WIDTH.count * HEIGHT.count )
    to_s
  end

  def tick(steps=1)
    steps.times do
      @cycles += 1
      @screen[ [draw_row, draw_column] ] = draw_sprite? ? LIT_PIXEL : DARK_PIXEL
    end
    self
  end

  def sprite
    [ x-1 , x , x+1 ]
  end

  def x
    @cpu.x_during_nth_cycle(@cycles)
  end

  def draw_sprite?
    sprite.include? draw_column
  end

  def draw_row
    ( (@cycles - 1) / 40) % 6
  end

  def draw_column
    ( (@cycles - 1) % 40)
  end

  def to_s
    HEIGHT.map { |row|
      WIDTH.map { |column|
        @screen[ [row, column] ]
      }.join("")
    }.join("\n") + "\n"
  end

  def sprite_to_s
    WIDTH.map{|c| sprite.include?(c) ? LIT_PIXEL : DARK_PIXEL}.join("")
  end

  def render_screen
    [
      "┏━" + "━".ljust(WIDTH.count, "━") + "━┓" ,
          self.to_s.split("\n").map{ |row|
      "┃ " + row +                         " ┃"},
      "┗━" + "━".ljust(WIDTH.count, "━") + "━┛" ,
    ].join("\n")
  end

  def render_sprite
    [
      "  Sprite position: x = #{x}",
      "╭ " + " ".ljust(WIDTH.count, " ") + " ╮",
      "│ " + sprite_to_s + " │",
      "╰ " + " ".ljust(WIDTH.count, " ") + " ╯",
    ].join("\n")
  end

  def diag
    cycle_info = "Cycle: #{@cycles}"
    [
      Day.clear_codes,
      "  Cycle: #{@cycles}",
      "",
      render_sprite,
      render_screen,
    ].join("\n")
  end
end
