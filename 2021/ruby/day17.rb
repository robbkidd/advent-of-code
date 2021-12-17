class Day17
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :target_area

  def initialize(input=nil)
    @input = input || real_input
    parse_input
  end

  # @example
  #   day.part1 #=> 45
  def part1
    probes_that_hit
      .max_by { |probe| probe.max_height }
      .max_height
  end

  # @example
  #   day.part2 #=> 112
  def part2
    probes_that_hit
      .map(&:launch_velocity) # excessive uniqueness check
      .uniq                   # because AoC Paranoia™
      .count
  end

  def probes_that_hit
    @winners ||=
      (0..target_area[:x].max)
        .filter {|vx| (vx * (vx+1))/2 >= target_area[:x].min }
        .flat_map { |test_vx|
          test_y_start = target_area[:y].min
          test_y_end = (target_area[:y].max.abs + target_area[:y].min.abs)
          (test_y_start..test_y_end).map {|test_vy|
            velocity = [test_vx, test_vy]
            Probe.new(velocity, target_area)
          }
        }
        .filter{ |probe| probe.hit? }
  end

  # @example
  #  day.parse_input
  #  day.target_area #=> {x: (20..30), y: (-10..-5)}
  def parse_input
    @target_area =
      @input
        .chomp
        .match(/x=(?<x>.*), y=(?<y>.*)$/)
        .named_captures
        .map { |axis, range_str|
          [
            axis.to_sym,
            eval(range_str) # eval is evil
          ]
        }.to_h
  end

  def real_input
    File.read('../inputs/day17-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    target area: x=20..30, y=-10..-5
  INPUT

  EXAMPLE_7_2_OUTPUT = <<~VIZ
    .............#....#............
    .......#..............#........
    ...............................
    S........................#.....
    ...............................
    ...............................
    ...........................#...
    ...............................
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................TTTTTTTT#TT
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
  VIZ

  EXAMPLE_6_3_OUTPUT = <<~VIZ
    ...............#..#............
    ...........#........#..........
    ...............................
    ......#..............#.........
    ...............................
    ...............................
    S....................#.........
    ...............................
    ...............................
    ...............................
    .....................#.........
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................T#TTTTTTTTT
    ....................TTTTTTTTTTT
  VIZ

  EXAMPLE_9_0_OUTPUT = <<~VIZ
    S........#.....................
    .................#.............
    ...............................
    ........................#......
    ...............................
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTT#
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
    ....................TTTTTTTTTTT
  VIZ
end


class Probe
  attr_reader :arc, :launch_velocity

  def initialize(velocity=[0,0], target={x: (0..0), y: (0..0)})
    @launch_velocity = velocity
    @target = target
  end

  def arc
    @arc ||= launch
  end

  # @example
  #   probe = Probe.new([6,9], day.target_area)
  #   probe.max_height #=> 45
  def max_height
    @max_height ||= arc.map(&:last).max
  end



  # @example
  #   probe = Probe.new([7,2], day.target_area)
  #   probe.hit? #=> true
  def hit?
    arc.any?{ |coord| in_target_area?(coord) }
  end

  def to_s
    "#{velocity} -> highest: #{max_height}, arc: #{arc}"
  end

  # @example 7,2
  #   probe = Probe.new([7,2], day.target_area)
  #   probe.viz #=> Day17::EXAMPLE_7_2_OUTPUT
  #   puts; puts probe.viz(highlight: true)
  # @example 6,3
  #   probe = Probe.new([6,3], day.target_area)
  #   probe.viz #=> Day17::EXAMPLE_6_3_OUTPUT
  #   puts; puts probe.viz(highlight: true)
  # @example 9,0
  #   probe = Probe.new([9,0], day.target_area)
  #   probe.viz #=> Day17::EXAMPLE_9_0_OUTPUT
  #   puts; puts probe.viz(highlight: true)
  def viz(highlight: false)
    arc_x_bounds,
    arc_y_bounds =
      arc
        .transpose
        .map{ |axis| Range.new(*axis.minmax) }

    column_bounds = Range.new(
      [@target[:x].min,arc_x_bounds.min].min,
      [@target[:x].max,arc_x_bounds.max].max,
    )
    row_bounds = Range.new(
      [@target[:y].min,arc_y_bounds.min].min,
      [@target[:y].max,arc_y_bounds.max].max,
    )

    row_bounds.max.downto(row_bounds.min).map { |r|
      column_bounds.map { |c|
        case
        when [0,0] == [c,r]
          highlight ? "\e[37m\e[41m\e[1mS\e[0m\e[32m" : "S"
        when arc.include?([c,r])
          highlight ? "\e[37m\e[41m\e[1m#\e[0m\e[32m" : "#"
        when in_target_area?([c,r])
          highlight ? "\e[1mT\e[22m" : "T"
        else
          "."
        end
      }.join.prepend(highlight ? "\e[0m\e[32m" : "")
    }.join("\n")
    .concat(highlight ? "\e[0m\n" : "\n")
  end

  private

  # @example 7,2
  #   probe = Probe.new([7,2], day.target_area)
  #   probe.arc #=> [[0, 0], [7, 2], [13, 3], [18, 3], [22, 2], [25, 0], [27, -3], [28, -7]]
  #   probe.hit? #=> true
  # @example 17,-4 (miss)
  #   probe = Probe.new([17,-4], day.target_area)
  #   probe.hit? #=> false
  def launch
    vx, vy = launch_velocity
    arc = []
    x, y = [0, 0]

    until over_shot?([x,y]) || past_the_floor?([x,y]) do
      arc.push([x,y])

      x += vx
      y += vy

      vx -= (vx > 0 ? 1 : 0)
      vy -= 1
    end

    @arc = arc
  end

  def in_target_area?(coord)
    @target[:x].cover?(coord.first) && @target[:y].cover?(coord.last)
  end

  def past_the_floor?(coord)
    coord.last < @target[:y].min
  end

  def over_shot?(coord)
    coord.first > @target[:x].max
  end
end
