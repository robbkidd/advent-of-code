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
		@day01 = Day01.new
	end

	def test_part1_example
		assert_equal 7, @day01.num_increases(PART1_EXAMPLE_INPUT)
	end
end
