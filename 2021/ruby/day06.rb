class Day06
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @school = RecursiveLanternFishSchool.new(input || real_input)
  end

  # @example 80 days
  #   d = Day06.new(EXAMPLE_INPUT)
  #   d.part1 #=> 5934
  def part1
    @school.size_on_day(80)
  end

  # @example 256 days
  #   d = Day06.new(EXAMPLE_INPUT)
  #   d.part2 #=> 26984457539
  def part2
    @school.size_on_day(256)
  end

  def real_input
    File.read('../inputs/day06-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    3,4,3,1,2
  INPUT
end

class RecursiveLanternFishSchool
  def initialize(list='')
    @recursive_school = { 0 => list.chomp.split(",").map(&:to_i).tally }
    @recursive_school.default_proc = proc do |hash, day|
      hash[day] = hash[day-1].each_with_object(Hash.new(0)) do |fish, next_school|
        days, count = fish
        if days == 0
          next_school[8] += count
          next_school[6] += count
        else
          next_school[days-1] += count
        end
      end
    end
  end

  # @example
  #   s = RecursiveLanternFishSchool.new(Day06::EXAMPLE_INPUT)
  #   s.size_on_day(18) #=> 26
  #   s.size_on_day(80) #=> 5934
  def size_on_day(day)
    @recursive_school[day].values.reduce(&:+)
  end
end

class LanternFishSchool
  attr_reader :school

  # @example
  #   LanternFishSchool
  #     .new('3,4,3,1,2')
  #     .school #=> {3=>2, 4=>1, 1=>1, 2=>1}
  def initialize(list='')
    @school = list.chomp.split(",").map(&:to_i).tally
  end

  # @example
  #   s = LanternFishSchool.new('6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8')
  #   s.size #=> [6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8].tally.values.reduce(&:+)
  def size
    school.values.reduce(&:+)
  end

  # @example 1 day
  #   LanternFishSchool
  #     .new('3,4,3,1,2')
  #     .a_day_passes
  #     .school #=> {2=>2, 3=>1, 0=>1, 1=>1}
  # @example 2 days
  #   LanternFishSchool
  #     .new('3,4,3,1,2')
  #     .a_day_passes
  #     .a_day_passes
  #     .school #=> {1=>2, 2=>1, 6=>1, 0=>1, 8=>1}
  # @example 3 days
  #   s = LanternFishSchool
  #     .new('3,4,3,1,2')
  #     .a_day_passes
  #     .a_day_passes
  #     .a_day_passes
  #   s.school #=> [0,1,0,5,6,7,8].tally
  #
  # @example 80 days
  #   s = LanternFishSchool.new(Day06::EXAMPLE_INPUT)
  #   80.times { s.a_day_passes }
  #   s.size #=> 5934
  #
  # @example 256 days
  #   s = LanternFishSchool.new(Day06::EXAMPLE_INPUT)
  #   256.times { s.a_day_passes }
  #   s.size #=> 26984457539
  #
  def a_day_passes
    new_fish = @school[0]

    @school = @school.each_with_object(Hash.new(0)) { |fish, next_school|
      days, count = fish
      if days == 0
        next_school[6] += count
      else
        next_school[days-1] += count
      end
    }

    @school[8] = new_fish if new_fish && new_fish > 0

    self
  end
end

require 'minitest'

class TestLanternFishSchool < Minitest::Test

  STATES = {
     1 => [2,3,2,0,1                                          ].tally,
     2 => [1,2,1,6,0,8                                        ].tally,
     3 => [0,1,0,5,6,7,8                                      ].tally,
     4 => [6,0,6,4,5,6,7,8,8                                  ].tally,
     5 => [5,6,5,3,4,5,6,7,7,8                                ].tally,
     6 => [4,5,4,2,3,4,5,6,6,7                                ].tally,
     7 => [3,4,3,1,2,3,4,5,5,6                                ].tally,
     8 => [2,3,2,0,1,2,3,4,4,5                                ].tally,
     9 => [1,2,1,6,0,1,2,3,3,4,8                              ].tally,
    10 => [0,1,0,5,6,0,1,2,2,3,7,8                            ].tally,
    11 => [6,0,6,4,5,6,0,1,1,2,6,7,8,8,8                      ].tally,
    12 => [5,6,5,3,4,5,6,0,0,1,5,6,7,7,7,8,8                  ].tally,
    13 => [4,5,4,2,3,4,5,6,6,0,4,5,6,6,6,7,7,8,8              ].tally,
    14 => [3,4,3,1,2,3,4,5,5,6,3,4,5,5,5,6,6,7,7,8            ].tally,
    15 => [2,3,2,0,1,2,3,4,4,5,2,3,4,4,4,5,5,6,6,7            ].tally,
    16 => [1,2,1,6,0,1,2,3,3,4,1,2,3,3,3,4,4,5,5,6,8          ].tally,
    17 => [0,1,0,5,6,0,1,2,2,3,0,1,2,2,2,3,3,4,4,5,7,8        ].tally,
    18 => [6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8].tally,
  }
  def test_states
    STATES.each do |days, school|
      s = LanternFishSchool.new('3,4,3,1,2')
      days.times { s.a_day_passes }
      assert_equal school, s.school, "Day #{days} mismatch"
    end
  end

  def test_recursive_size
    s = RecursiveLanternFishSchool.new('3,4,3,1,2')
    STATES.each do |days, school|
      assert_equal school.values.reduce(&:+), s.size_on_day(days), "Day #{days} mismatch"
    end
  end
end
