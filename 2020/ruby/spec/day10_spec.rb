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
    let(:chain1) { AdapterChain.new(example_input_1) }
    let(:chain2) { AdapterChain.new(example_input_2) }

      
    context "figures out joltage differences" do
      it "for example 1" do
        expect(chain1.joltage_differences).to eq([1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 3, 3])
      end
      it "for example 2" do
        expect(chain2.joltage_differences).to eq([1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 3, 1, 1, 1, 3, 1, 1, 3, 3, 1, 1, 1, 1, 3, 1, 3, 3, 1, 1, 1, 1, 3])
      end
    end

    context "figures out joltage distribution" do
      it "for example 1" do
        expect(chain1.joltage_distribution).to eq({1 => 7, 3 => 5})
      end
      it "for example 2" do
        expect(chain2.joltage_distribution).to eq({1 => 22, 3 => 10})
      end
    end

    context "finds valid arrangements" do
      it "for example 1" do
        expect(chain1.arrangements).to eq({}) # 8
      end
      it "for example 2" do
        expect(chain2.arrangements).to eq({}) # 19_208
      end
    end
  end
end