class Day21
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  # @example
  #   day.part1 #=> 739785
  def part1
    players =
      parse_input
        .map{ |start| DiracPlayer.new(start) }

    die = DeterministicDie.new

    (1..).each do |turn|
      if turn.odd?
        players[0].take_turn(die)
      else
        players[1].take_turn(die)
      end

      break if players.any? { |p| p.win? }
    end

    loser = players.min_by { |p| p.score }

    loser.score * die.times_rolled
  end

  def part2
  end

  # @example
  #   day.parse_input #=> [4, 8]
  def parse_input
    @input
      .split("\n")
      .map{|line| line.split(": ").last.to_i}
  end

  def real_input
    File.read('../inputs/day21-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    Player 1 starting position: 4
    Player 2 starting position: 8
  INPUT
end

class DiracPlayer
  attr_reader :pawn, :score, :name

  def initialize(starting_space, name='')
    @name = name
    @pawn = starting_space
    @score = 0
  end

  def win?
    score >= 1000
  end

  # @example
  #   p1 = DiracPlayer.new(4)
  #   p2 = DiracPlayer.new(8)
  #   die = DeterministicDie.new
  #   p1.take_turn(die)
  #   p1.pawn #=> 10
  #   p1.score #=> 10
  #   p2.take_turn(die)
  #   p2.pawn #=> 3
  #   p2.score #=> 3
  #   p1.take_turn(die)
  #   p1.pawn #=> 4
  #   p1.score #=> 14
  def take_turn(die)
    # scoot it back one for mod'ing
    forward = 3.times.map{|_| die.roll}.reduce(&:+) - 1
    # then bump it forward one because
    # mod10==0 means pawn is on [1] on the track
    @pawn = ((@pawn + forward) % 10) + 1
    @score += @pawn
    self
  end
end

class DeterministicDie
  attr_reader :times_rolled, :faces

  # @example
  #   die = DeterministicDie.new
  #   die.faces.first #=> 1
  #   die.faces.last #=> 100
  #   die.faces.length #=> 100
  def initialize(how_many_sides=100)
    @ptr = -1
    @times_rolled = 0
    @faces = (1..how_many_sides).to_a.freeze
  end

  # @example rollin'
  #   die = DeterministicDie.new
  #   3.times.map {|_| die.roll } #=> [1,2,3]
  #   die.times_rolled #=> 3
  # @example wrap around
  #   die = DeterministicDie.new
  #   99.times { die.roll }
  #   3.times.map {|_| die.roll } #=> [100, 1, 2]
  #   die.times_rolled #=> 102
  def roll
    @times_rolled += 1
    @ptr = @ptr < 99 ? @ptr += 1 : 0
    @faces[@ptr]
  end
end
