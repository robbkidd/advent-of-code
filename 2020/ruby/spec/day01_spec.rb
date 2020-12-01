require 'rspec'
require_relative '../lib/day01'

describe ExpenseAudit do
  describe "part1 - example" do
    it "finds the pair that sums to 2020" do
      audit = described_class.new([1721, 979, 366, 299, 675, 1456])
      result = audit.which_pair_is_2020
      expect(result).to eq([1721, 299])
    end
  end

  describe "part 2 - example" do
    it "finds the triplet that sums to 2020" do
      audit = described_class.new([1721, 979, 366, 299, 675, 1456])
      result = audit.which_triplet_is_2020
      expect(result).to eq([979, 366, 675]) 
    end
  end
end
