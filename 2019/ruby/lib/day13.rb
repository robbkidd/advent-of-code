class Day13
  def self.go
    puts "Part1: #{part1}"
    puts "\nPart2: #{part2}"
  end

  def self.part1
    game = Breakout.new(software: break_out_software)
    game.run
    game.screen.filter{|_, tile| tile == :block}.count
  end

  def self.part2
    game = Breakout.new(software: break_out_software, freeplay: true)
    game.run
    game.update_display
    game.score
  end

  def self.break_out_software
    File.read('../inputs/day13-input.txt').chomp.split(",").map(&:to_i)
  end
end

class Breakout
  require_relative 'intcode'

  TILE_TYPES = %i(empty wall block paddle ball)

  attr_reader :computer, :debug, :screen, :score, :threads

  def initialize(software:, freeplay: false, debug: false)
    @debug = debug
    @software = software
    if freeplay
      @software[0] = 2
    end

    @computer = Intcode.new(program: @software, input: [], debug: @debug)
    @computer.output = Queue.new

    @screen = Hash.new(nil)
    @screen[[0,0]] = :empty
    @score = 0

    @threads = {}
  end

  def run
    @threads[:brain] = Thread.new do
      debug_puts "🧵  Starting #{computer.name}"
      computer.run
      while not computer.halted?
        sleep 0.01
      end
    end

    @ball_x = 0
    @paddle_x = 0

    #computer.output_proc = Proc.new do
    @threads[:tile_updater] = Thread.new do
      buffer = []
      while not computer.halted?
        buffer << computer.output.shift
        next unless buffer.length == 3

        x, y, value = *buffer

        if [x,y] == [-1,0]
          @score = value
          debug_puts "🧵  score: #{@score} "
          #update_display
        else
          tile = TILE_TYPES[value]
          @screen[[x,y]] = tile

          debug_puts "🧵  tile at #{x}, #{y} #{tile} "

          case tile
          when :ball
            @ball_x = x
          when :paddle
            @paddle_x = x
          end
        end
        buffer = []
      end
    end

    #@computer.input_proc = Proc.new do
    @threads[:joystick] = Thread.new do
      while not computer.halted?
        if computer.input.empty?
          computer.receive_input((@ball_x - @paddle_x).clamp(-1,1))
          #update_display
        end
        sleep 0.6
      end
    end

    debug_puts "🧵  🎬 : Game Started"
    @threads.values.map(&:join)
    # computer.run
  end

  def update_display
    #  return
    # system("cls")
    # system("clear")
    # debug_puts @threads.map{ |component, thread| "#{component}: #{thread.status}"}.join(" | ")
    puts "SCORE: #{@score}"
    puts render
  end

  def render
    x_min, x_max = screen.map{|loc,_| loc[0]}.minmax
    y_min, y_max = screen.map{|loc,_| loc[1]}.minmax

    (y_min..y_max).map do |y|
      (x_min..x_max).map do |x|
        case screen[[x,y]]
        when :empty; " "
        when :wall
          case y
          when y_min
            case x
            when x_min; "╔"
            when x_max; "╗"
            else "═"
            end
          else "║"
          end
        when :block; "█"
        when :paddle; "─"
        when :ball; "o"
        end
      end.join("")
    end.join("\n")
  end

  def debug_puts(msg)
    puts msg if debug
  end
end
