class Day04
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def part1
    bingo = BingoSubSystem.new(input)
    chicken_dinner = bingo.first_winning_board
    chicken_dinner.score
  end

  def part2
    bingo = BingoSubSystem.new(input)
    tofurky_dinner = bingo.last_winning_board
    tofurky_dinner.score
  end

  def input
    File.read('../inputs/day04-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
  INPUT
end

class BingoSubSystem
  attr_reader :drawn_numbers, :boards

  def initialize(input='')
    round_generator(input)
  end

  def round_generator(input)
    stanzas = input.split("\n\n")
    @drawn_numbers = stanzas.shift.split(",").map(&:to_i)
    @boards = stanzas.map { |s| Board.new(s) }
  end

  def first_winning_board
    @drawn_numbers.each do |draw|
      @boards.each do |board|
        board.match(draw)
        return board if board.won?
      end
    end
  end

  def last_winning_board
    winners = []
    @drawn_numbers.each do |draw|
      @boards.each do |board|
        next if board.won?
        board.match(draw)
        winners << board if board.won?
      end
      break if winners.length == @boards.length
    end
    winners.last
  end
end

class Board
  attr_reader :tiles

  def initialize(input='')
    @tiles = parse(input)
    @matches = []
    @won = false
  end

  def won?
    @won
  end

  def score
    @matches.last * tiles
      .flatten
      .reject(&:marked?)
      .map(&:number)
      .reduce(&:+)
  end

  def to_s
    tiles
      .map { |row|
        row
          .map{ |tile| tile.to_s }
          .join(" ")
      }
      .join("\n")
      .concat("\n")
  end

  def match(number)
    if won?
      puts "Why are you still playing?"
      return self
    end

    tiles
      .each do |row|
        row.each do |tile|
          if tile.match?(number)
            @matches << number
            tile.mark
            if is_a_winner?
              @won = true
              return self
            end
          end
        end
      end
  end

  def is_a_winner?
    tiles.any? { |row| row.all? {|tile| tile.marked? } } ||
    tiles.transpose.any? { |column| column.all? {|tile| tile.marked? } }
  end

  def parse(input='')
    input
      .split("\n")
      .map { |row|
        row
          .split(" ")
          .map { |number| Tile.new(number.to_i) }
      }
  end
end

Tile = Struct.new(:number) do
  def mark
    @marked = true
  end

  def match?(other)
    number == other
  end

  def +(other)
    number + other.number
  end

  def marked?
    !!@marked
  end

  def to_i
    number
  end

  def to_s
    number
      .to_s
      .rjust(2)
      .tap { |t|
        t.prepend("\e[7m").concat("\e[0m") if marked?
      }
  end
end

require 'minitest'

class TestDay04 < Minitest::Test
  def setup
    @third_example_board = Board.new(<<~BOARD)
      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
       2  0 12  3  7
    BOARD
  end

  def test_first_winning_board
    bingo = BingoSubSystem.new(Day04::EXAMPLE_INPUT)
    chicken_dinner = bingo.first_winning_board
    assert_equal 4512, chicken_dinner.score
  end

  def test_last_winning_board
    bingo = BingoSubSystem.new(Day04::EXAMPLE_INPUT)
    tofurky_dinner = bingo.last_winning_board
    assert_equal 1924, tofurky_dinner.score
  end

  def test_input_parsing
    bingo = BingoSubSystem.new(Day04::EXAMPLE_INPUT)
    assert_equal(
      [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1],
      bingo.drawn_numbers
    )
    # assert_equal "", d.boards
  end

  def test_board_won?
    b = @third_example_board
    [14,10,18,22,2].each {|draw| b.match(draw)}
    assert b.won?
  end

  def test_board_score
    b = @third_example_board
    refute b.won?
    [7,4,9,5,11,17,23,2,0,14,21].each do |draw|
      b.match(draw)
      refute b.won?
    end
    b.match(24)
    assert b.won?
    assert_equal 4512, b.score
  end

  def test_tile_marking
    tile = Tile.new(84)
    assert_equal 84, tile.number
    refute tile.marked?
    tile.mark
    assert tile.marked?
  end
end

if ENV.key? 'TEST'
  require 'minitest/autorun'
else
  Day04.go
end
