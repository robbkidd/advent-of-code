class Claim
  attr_accessor :id, :x_start, :x_length, :y_start, :y_length, :all_the_coords

  def initialize(input)
    @id, _, coords, dimensions = input.delete(':').split(' ')
    @x_start, @y_start = coords.split(',').map(&:to_i).map {|i| i+1 }
    @x_length, @y_length = dimensions.split('x').map(&:to_i)
    @all_the_coords = compute_all_the_coords
  end

  def self.part1
    input = File.read('day03-input.txt').split("\n")
    claims = input.map {|line| Claim.new(line)}
    coords_in_overlaps(claims).count
  end

  def self.part2
    input = File.read('day03-input.txt').split("\n")
    claims = input.map {|line| Claim.new(line)}
    claims_with_no_conflicts(claims)
  end

  def self.coords_in_overlaps(claims)
    overlap_set = Set.new
    claims.each do |left_claim|
      claims.each do |right_claim|
        if left_claim.id != right_claim.id
          overlap_set.merge(left_claim.overlapping_coords(right_claim))
        end
      end
    end
    overlap_set
  end

  def self.claims_with_no_conflicts(claims)
    claims.select do |claim|
      claims.select { |scan| (claim.id != scan.id) && claim.overlaps?(scan) }.empty?
    end.map(&:id)
  end

  def compute_all_the_coords
    (x_start...(x_start+x_length)).map do |x|
      (y_start...(y_start+y_length)).map do |y|
        "#{x},#{y}"
      end
    end.flatten
  end

  def overlapping_coords(other)
    self.all_the_coords & other.all_the_coords
  end

  def overlaps?(other)
    !overlapping_coords(other).empty?
  end
end

require 'rspec'

describe Claim do
  let(:claims) do
    input = <<~EXAMPLE
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
    EXAMPLE
    claims = input.split("\n").map {|line| Claim.new(line)}
  end

  it 'overlappage' do
    expected_overlap = Set["4,4", "4,5", "5,4", "5,5"]
    expect(described_class.coords_in_overlaps(claims)).to eq(expected_overlap)
  end

  it 'finds the one that does not overlap' do
    expect(described_class.claims_with_no_conflicts(claims)).to eq(['#3'])
  end

  it 'makes new claims' do
    claim = Claim.new("#1 @ 1,3: 4x4")
    expect(claim.id).to eq('#1')
    expect(claim.x_start).to eq(2)
    expect(claim.y_start).to eq(4)
    expect(claim.x_length).to eq(4)
    expect(claim.y_length).to eq(4)
  end

  it 'figures out the overlap box' do
    claim1 = Claim.new("#1 @ 1,3: 4x4")
    claim2 = Claim.new("#2 @ 3,1: 4x4")
    expect(claim1.overlapping_coords(claim2)).to eq(["4,4", "4,5", "5,4", "5,5"])
    expect(claim1.overlaps?(claim2)).to be true
    expect(claim2.overlaps?(claim1)).to be true
    claim3 = Claim.new("#3 @ 5,5: 2x2")
    expect(claim1.overlaps?(claim3)).to be false
    expect(claim2.overlaps?(claim3)).to be false
  end
end