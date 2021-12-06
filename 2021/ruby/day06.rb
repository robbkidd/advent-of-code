class Day06
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example 18 days
  #   s = LanternFishSchool.new(EXAMPLE_INPUT)
  #   18.times { s.a_day_passes }
  #   s.school.count #=> 26
  #
  # @example 80 days
  #   d = Day06.new(EXAMPLE_INPUT)
  #   d.part1 #=> 5934
  def part1
    s = LanternFishSchool.new(input)
    80.times { s.a_day_passes }
    s.school.count
  end

  def part2
  end

  def real_input
    File.read('../inputs/day06-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    3,4,3,1,2
  INPUT
end

class LanternFishSchool
  attr_reader :school

  # @example
  #   LanternFishSchool
  #     .new('1,2,3')
  #     .school #=> [1,2,3]
  def initialize(list='')
    @school = list.chomp.split(",").map(&:to_i)
  end

  # @example 1 day
  #   LanternFishSchool
  #     .new('3,4,3,1,2')
  #     .a_day_passes
  #     .school #=> [2,3,2,0,1]
  # @example 2 days
  #   LanternFishSchool
  #     .new('3,4,3,1,2')
  #     .a_day_passes
  #     .a_day_passes
  #     .school #=> [1,2,1,6,0,8]
  #
  def a_day_passes
    new_fish = @school.count(0)
    @school = @school.map { |fish_days|
      fish_days == 0 ? 6 : fish_days - 1
    }.append([8] * new_fish).flatten
    self
  end
end
