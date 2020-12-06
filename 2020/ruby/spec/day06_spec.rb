require 'rspec'
require_relative '../lib/day06'

describe Day06 do
  let(:example_day) {
    Day06.new(<<~INPUT)
      abc

      a
      b
      c
      
      ab
      ac
      
      a
      a
      a
      a
      
      b
    INPUT
  }

  it "Part1" do
    expect(example_day.part1).to eq(11)
  end

  it "Part2"
end