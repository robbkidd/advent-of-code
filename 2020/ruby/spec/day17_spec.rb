require 'rspec'
require_relative '../lib/day17'

describe ConwayCubes do
  let(:example_dimension) {
    described_class.new(Day17.example_input)
  }

  it "has 3D offsets" do
    expect(example_dimension.offsets.count).to eq(26)
  end

  it "part 1" do
    6.times { example_dimension.tick }
    expect(example_dimension.currently_active.count).to eq(112)
  end
end

describe ConwayHypercubes do
  let(:example_dimension) {
    described_class.new(Day17.example_input)
  }

  it "has 4D offsets" do
    expect(example_dimension.offsets.count).to eq(80)
  end

  it "part 2" do
    6.times { example_dimension.tick }
    expect(example_dimension.currently_active.count).to eq(848)
  end
end
