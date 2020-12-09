require 'rspec'
require_relative '../lib/day09'

describe "Day 9" do
  let(:example_input) {
    <<~EXAMPLE
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
    EXAMPLE
  }

  describe XMAS do
    it "parses example input" do
      data = XMAS.new("")
      expect(data.parse_input(example_input).take(3)).to eq [35, 20, 15]
    end

    it "finds the first invalid number" do
      data = XMAS.new(example_input, 5)
      expect(data.first_invalid).to eq 127
    end
  end
end