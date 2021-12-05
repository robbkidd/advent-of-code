class Day05
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def part1
    parse(input)
      .map{ |line| to_vent_line(line) }
      .flatten(1)
      .tally
      .reject{ |coord, count| count < 2 }
      .length
  end

  def part2
    parse(input)
      .map{ |line| to_vent_line(line, skip_diagonals: false) }
      .flatten(1)
      .tally
      .reject{ |coord, count| count < 2 }
      .length
  end

  def input
    File.read('../inputs/day05-input.txt')
  end

  def to_vent_line(end_coords, skip_diagonals: true)
    start, finish = end_coords
    case
    when start[1] == finish[1]
      xs = fill_a_dimension(start[0], finish[0])
      ys = [start[1]] * xs.length
      (xs).to_a.zip(ys)
    when start[0] == finish[0]
      ys = fill_a_dimension(start[1], finish[1])
      xs = [start[0]] * ys.length
      (xs).to_a.zip(ys)
    else
      if skip_diagonals
        []
      else
        xs = fill_a_dimension(start[0], finish[0])
        ys = fill_a_dimension(start[1], finish[1])
        xs.zip(ys)
      end
    end
  end

  def fill_a_dimension(e1, e2)
    e1 > e2 ? e1.downto(e2).to_a : e1.upto(e2).to_a
  end

  def parse(input)
    input
      .split("\n")
      .map{ |line|
        line.split(" -> ")
        .map{ |coords| coords.split(",").map(&:to_i)}
      }
  end

  EXAMPLE_INPUT = <<~INPUT
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  INPUT
end

require 'minitest'

class TestDay05 < Minitest::Test
  def test_parse_input
    d = Day05.new
    assert_equal [[0,9],[5,9]], d.parse(Day05::EXAMPLE_INPUT).first
  end

  def test_to_vent_line
    d = Day05.new
    assert_equal [[1, 1], [1, 2], [1, 3]], d.to_vent_line([[1,1],[1,3]])
  end

  def test_other_line
    d = Day05.new
    assert_equal [[9, 7], [8, 7], [7, 7]], d.to_vent_line([[9,7],[7,7]])
  end
end

if ENV.key? 'TEST'
  require 'minitest/autorun'
else
  Day05.go
end
