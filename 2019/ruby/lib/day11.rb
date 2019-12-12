class Day11
  def self.go
    puts "Part1: #{part1}"
    puts "\nPart2: \n#{part2}"
  end

  def self.part1
    puts "... this will take a while ..."
    robot = RobotPainter.new(software: Day11.painting_robot_software)
    robot.run
    robot.panels.length
  end

  def self.part2
    robot = RobotPainter.new(software: Day11.painting_robot_software, start_on_color: :white)
    robot.run
    robot.registration
  end

  def self.painting_robot_software
    File.read('../inputs/day11-input.txt').chomp.split(",").map(&:to_i)
  end
end

class RobotPainter
  require_relative 'intcode'

  attr_reader :computer, :debug, :brain, :worker, :panels
  def initialize(software:, debug: false, start_on_color: :black)
    @debug = debug
    @software = software
    @computer = Intcode.new(program: @software, input: [], debug: @debug)
    @brain = nil
    @worker = nil
    @panels = Hash.new { |panels, location| panels[location] = :black }
    @start_on_color = start_on_color
  end

  def run
    brain = Thread.new do
      debug_puts "🧵  Starting #{computer.name}"
      computer.run
      while not computer.halted?
        sleep 0.01
      end
    end

    start_at = [0,0]
    panels[start_at] = @start_on_color
    facing = '^'

    worker = Thread.new do
      current_location = start_at
      debug_puts "🧵  🎬 : #{facing} - #{current_location} - #{panels[current_location]}"

      case panels[current_location]
      when :black
        computer.receive_input(0)
      when :white
        computer.receive_input(1)
      end

      while not computer.halted?
        while computer.output.empty?
          sleep 0.001
        end

        color_to_paint = computer.output.shift
        debug_puts "🧵  🎨 🤷 ‍: #{color_to_paint}"

        case color_to_paint
        when 0
          panels[current_location] = :black
        when 1
          panels[current_location] = :white
        end
        debug_puts "🧵  🖌 : #{current_location} - #{panels[current_location]}"


        while computer.output.empty?
          sleep 0.001
        end

        direction_to_turn = computer.output.shift
        debug_puts "🧵  🗺 🤷 ‍: #{direction_to_turn}"

        facing = make_turn(facing, direction_to_turn)
        current_location = move_robot(facing, current_location)
        debug_puts "🧵  🚶‍♀️ : #{facing} - #{current_location}"

        case panels[current_location]
        when :black
          computer.receive_input(0)
        when :white
          computer.receive_input(1)
        end

        debug_puts "🧵  👁 : #{current_location} - #{panels[current_location]}"
      end
    end

    [brain,worker].map(&:join)
  end

  def registration
    x_min, x_max = panels.map{|loc,_| loc[0]}.minmax
    y_min, y_max = panels.map{|loc,_| loc[1]}.minmax

    (y_min..y_max).map do |y|
      (x_min..x_max).map do |x|
        case panels[[x,y]]
        when :black; " "
        when :white; "#"
        end
      end.join("")
    end.join("\n")
  end

  def make_turn(facing, instruction)
    case [facing, instruction]
    when ['^', 0]; '<'
    when ['>', 0]; '^'
    when ['v', 0]; '>'
    when ['<', 0]; 'v'
    when ['^', 1]; '>'
    when ['>', 1]; 'v'
    when ['v', 1]; '<'
    when ['<', 1]; '^'
    end
  end

  def move_robot(facing, current_location)
    x, y = current_location
    case facing
    when '>'; [x + 1, y]
    when '<'; [x - 1, y]
    when 'v'; [x, y + 1]
    when '^'; [x, y - 1]
    end
  end

  def debug_puts(msg)
    puts msg if debug
  end
end
