class Day06
  def self.part1
    day06 = new(File.read('day06-input.txt').chomp)
  end

  def self.part2
  end

  attr_reader :mmx, :mmy

  def initialize(input)
    @input = input.split("\n")
  end

  def tinker
    the_world.map do |location|
      interesting_coords.map do |coord|
         { id: location == coord ? coord.id : coord.id.downcase,
           distance: location.distance(coord)
         }
      end.reject { |result| result[:id].match(/[A-Z]/)}
         .sort_by { |result| result[:distance] }
         .last(2)
    end
  end

  def interesting_coords
    @interesting_coords ||= @input.map { |line| line.split(', ') }
                                  .zip(names(@input.length))
                                  .map { |line, id| Coordinate.new(*line, id) }
  end

  def the_world

    @the_world ||= Range.new(*mmx).flat_map {|x| Range.new(*mmy).map {|y| Coordinate.new(x,y) } }
  end

  def mmx
    @mmx ||= interesting_coords.map(&:x).minmax
  end

  def mmy
    @mmy ||= interesting_coords.map(&:y).minmax
  end

  def is_edgy?(coordinate)
    mmx.include?(coordinate.x) || mmy.include?(coordinate.y)
  end

  def names(how_many)
    letters = ('A'..'Z').to_a
    numbers = (0..(how_many/letters.length)).to_a
    numbers.product(letters).map(&:join)
  end
end

class Coordinate
  attr_reader :x, :y
  attr_accessor :id

  def initialize(x, y, id='??')
    @x = x.to_i
    @y = y.to_i
    @id = id
  end

  def distance(other)
    (self.x - other.x).abs + (self.y - other.y).abs
  end

  def closest_point(points)
    points.map do |coord|
      { id: self == coord ? coord.id : coord.id.downcase,
        distance: self.distance(coord)
      }
   end.reject { |result| result[:id].match(/[A-Z]/)}
      .sort_by { |result| result[:distance] }
      # .last(2)
      # .each_cons(2)
      # .map{|p,n| p[:distance] == n[:distance] ? '..' : n[:id]}
  end

  def ==(other)
    other.is_a?(self.class) && other.x == x && other.y == y
  end
end

require 'rspec'

describe Coordinate do
  it 'can crank out coordinates' do
    coord = Coordinate.new(*'1, 9'.split(', '))
    expect(coord.x).to eq 1
    expect(coord.y).to eq 9
    expect(coord.id).to eq '??'
  end

  it 'can crank out coordinates' do
    coord = Coordinate.new(1, 9, '5G')
    expect(coord.x).to eq 1
    expect(coord.y).to eq 9
    expect(coord.id).to eq '5G'
  end

  it 'computes the manhatten distance to another coordinate' do
    a = Coordinate.new(1, 10)
    b = Coordinate.new(100, 1000)
    expect(a.distance(b)).to eq 1089
  end
end