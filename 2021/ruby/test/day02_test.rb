require 'minitest/autorun'
require 'day02'

class TestSub < Minitest::Test
  def setup
    @test_sub = Sub.new
  end

  def test_planned_course
    @test_sub.follow_instructions(Day02::EXAMPLE_INPUT)
    assert_equal 150, @test_sub.where_you_at
  end

  def test_sub_has_props
    assert_equal 0, @test_sub.depth
    assert_equal 0, @test_sub.horiz_pos
  end

  def test_sub_can_move_forward
    @test_sub.send("forward".to_sym, 42)
    @test_sub.send("forward".to_sym, 8)
    assert_equal 50, @test_sub.horiz_pos
  end

  def test_sub_can_dive
    @test_sub.send("down".to_sym, 3)
    @test_sub.send("down".to_sym, 2)
    assert_equal 5, @test_sub.depth
  end

  def test_sub_can_dive_and_rise
    @test_sub.down(20)
    @test_sub.send("up".to_sym, 4)
    @test_sub.send("up".to_sym, 9)
    assert_equal 7, @test_sub.depth
  end
end

class TestSlightlyMoreComplicatedSub < Minitest::Test
  def setup
    @test_sub = SlightlyMoreComplicatedSub.new
  end

  def test_planned_course
    @test_sub.follow_instructions(Day02::EXAMPLE_INPUT)
    assert_equal 900, (@test_sub.horiz_pos * @test_sub.depth)
  end

  def test_sub_has_props
    assert_equal 0, @test_sub.depth
    assert_equal 0, @test_sub.horiz_pos
  end

  def test_sub_can_move_forward
    @test_sub.forward(5)
    assert_equal 5, @test_sub.horiz_pos
  end

  def test_sub_can_dive
    @test_sub.down(5)
    assert_equal 0, @test_sub.depth
  end

  def test_sub_can_do_the_aim_thing
    @test_sub.forward(5)
    assert_equal 0, @test_sub.where_you_at

    @test_sub.down(5)
    assert_equal 5, @test_sub.aim

    @test_sub.forward(8)
    assert_equal 40, @test_sub.depth
  end
end
