require 'minitest/autorun'
require 'day01'

class TestDay01 < Minitest::Test
  PART1_EXAMPLE_INPUT=[
    199,
    200,
    208,
    210,
    200,
    207,
    240,
    269,
    260,
    263,
  ]

  def setup
    @day01_example = Day01.new(PART1_EXAMPLE_INPUT)
  end

  def test_part1_example
    assert_equal 7, @day01_example.part1
  end

  def test_part2_example
    assert_equal 5, @day01_example.part2
  end
end
