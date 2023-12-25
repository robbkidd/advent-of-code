require_relative 'day'

class Day24 < Day # >

  def set_test_area(min, max)
    @test_area = Range.new(min, max)
  end

  # @example
  #   day.set_test_area(7, 27)
  #   day.part1 #=> 2
  def part1
    @test_area ||= set_test_area(200_000_000_000_000, 400_000_000_000_000)

    input
      .split("\n")
      .map { |line| Hailstone.new(line) }
      .combination(2)
      .filter_map { |a, b| a.intersection_2d(b) }
      .select { |x_int, y_int| @test_area.cover?(x_int) && @test_area.cover?(y_int) }
      .count
  end

  # example
  #   day.part2 #=> '?'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    19, 13, 30 @ -2,  1, -2
    18, 19, 22 @ -1, -1, -2
    20, 25, 34 @ -2, -2, -4
    12, 31, 28 @ -1, -2, -1
    20, 19, 15 @  1, -5, -3
  INPUT
end

class Hailstone
  attr_reader :x, :y, :z, :vx, :vy, :vz, :m, :c

  # @example
  #   h = new("19, 13, 30 @ -2,  1, -2")
  #   [h.x, h.y, h.z] #=> [19, 13, 30]
  #   [h.vx, h.vy, h.vz] #=> [-2, 1, -2]
  #   h.m #=> -0.5
  def initialize(line)
    @x, @y, @z, @vx, @vy, @vz = line.tr("@", ",").split(/\s*,\s*/).map(&:to_i)
    @m = @vy/@vx.to_f
    @c = @y - (@m * @x)
  end

  # @example 1
  #   a = new("19, 13, 30 @ -2, 1, -2")
  #   b = new("18, 19, 22 @ -1, -1, -2")
  #   a.intersection_2d(b) #=> [14.333, 15.334]
  # @example 2
  #   a = new("19, 13, 30 @ -2, 1, -2")
  #   b = new("20, 25, 34 @ -2, -2, -4")
  #   a.intersection_2d(b) #=> [11.667, 16.667]
  # @example 3
  #   a = new("19, 13, 30 @ -2, 1, -2")
  #   b = new("12, 31, 28 @ -1, -2, -1")
  #   a.intersection_2d(b) #=> [6.2, 19.4]
  # @example 4_crossed_in_the_past
  #   a = new("19, 13, 30 @ -2, 1, -2")
  #   b = new("20, 19, 15 @ 1, -5, -3")
  #   a.intersection_2d(b) #=> nil
  # @example 5_parallel
  #   a = new("18, 19, 22 @ -1, -1, -2")
  #   b = new("20, 25, 34 @ -2, -2, -4")
  #   a.intersection_2d(b) #=> nil
  def intersection_2d(other)
    return nil if self.m == other.m # if slopes match, they're parallel

    x_int = ((other.c - self.c) / (self.m - other.m).to_f).round(3)
    y_int = (self.m * x_int + self.c).round(3)

    return nil if self.in_the_past?(x_int, y_int) || other.in_the_past?(x_int, y_int)

    [x_int, y_int]
  end

  def in_the_past?(new_x, new_y)
    (self.x > new_x && self.vx > 0) || # the new X is less than start, but the vector for X is positive
      (self.x < new_x && self.vx < 0)  # the new X is greater than start, but the vector for X is negative
  end
end
