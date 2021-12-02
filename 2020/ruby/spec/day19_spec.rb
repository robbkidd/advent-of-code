require 'rspec'
require_relative '../lib/day19'

describe MIBSatelliteMessageValidator do

  context "part1" do
    context "first example" do
      let(:checker) { MIBSatelliteMessageValidator.new(Day19.example1) }
      it "works with first example" do
        expect(checker.rules).to be_a Hash
        expect(checker.rules[0]).to eq("1 2")
        expect(checker.rules[3]).to eq("b")
      end

      it "validates messages" do
        expect(checker.message_valid_for_rule?("aab", 0)).to be true
        expect(checker.message_valid_for_rule?("aba", 0)).to be true
      end
    end

    context "example input" do
      let(:checker) { MIBSatelliteMessageValidator.new(Day19.example_input) }

      it "works with example input" do
        expect(checker.rules).to be_a Hash
        expect(checker.rules[0]).to eq("4 1 5")
        expect(checker.rules[5]).to eq("b")
      end

      it "validates messages" do
        expect(checker.message_valid_for_rule?("ababbb", 0)).to be true
        expect(checker.message_valid_for_rule?("abbbab", 0)).to be true
        expect(checker.message_valid_for_rule?("bababa", 0)).to be false
        expect(checker.message_valid_for_rule?("aaabbb", 0)).to be false
        expect(checker.message_valid_for_rule?("aaaabbb", 0)).to be false

      end
    end
  end


end
