require_relative "day13"

RSpec.describe SignalAnalyzer::PacketPair do
  it "Pair_1" do
    p = described_class.new(1, "[1,1,3,1,1]", "[1,1,5,1,1]")
    expect(p.analyze).to eq -1
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[1]
  end

  it "Pair 2" do
    p = described_class.new(2, "[[1],[2,3,4]]", "[[1],4]")
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[2]
    expect(result).to eq -1
  end

  it "Pair 3" do
    p = described_class.new(3, "[9]", "[[8,7,6]]")
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[3]
    expect(result).to eq 1
  end
  it "Pair 4" do
    p = described_class.new(4, "[[4,4],4,4]", "[[4,4],4,4,4]")
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[4]
    expect(result).to eq -1
  end
  it "Pair 5" do
    p = described_class.new(5, "[7,7,7,7]", "[7,7,7]")
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[5]
    expect(result).to eq 1
  end
  it "Pair 6" do
    p = described_class.new(6, "[]", "[3]")
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[6]
    expect(result).to eq -1
  end
  it "Pair 7" do
    p = described_class.new(7, "[[[]]]", "[[]]")
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[7]
    expect(result).to eq 1
  end
  it "Pair 8" do
    p =
      described_class.new(
        8,
        "[1,[2,[3,[4,[5,6,7]]]],8,9]",
        "[1,[2,[3,[4,[5,6,0]]]],8,9]"
      )
    result = p.analyze
    expect(p.diag).to eq Day13::EXAMPLE_RESULTS[8]
    expect(result).to eq 1
  end
end
