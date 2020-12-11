require 'rspec'
require_relative '../lib/day10'

describe "Day 9" do
  let(:example_input_1) {
    <<~EXAMPLE
      16
      10
      15
      5
      1
      11
      7
      19
      6
      12
      4
    EXAMPLE
  }

  let(:example_input_2) {
    <<~EXAMPLE
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
    EXAMPLE
  }

  describe AdapterChain do
    it "figures out joltage differences" do
      chain1 = AdapterChain.new(example_input_1)
      expect(chain1.joltage_differences).to eq({1 => 7, 3 => 5})
      chain2 = AdapterChain.new(example_input_2)
      expect(chain2.joltage_differences).to eq({1 => 22, 3 => 10})
    end
  end
end