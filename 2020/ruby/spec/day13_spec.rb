require 'rspec'
require_relative '../lib/day13'

describe "BusSchedule" do
  let(:example) { BusSchedule.new(Day13.example_input) }

  it "has an earliest timestamp" do
    expect(example.earliest_time).to eq 939
  end

  it "has a list of buses" do
    expect(example.buses).to eq [7, 13, 59, 31, 19]
  end

  it "finds the next arriving bus" do
    expect(example.next_arriving_bus).to eq(
      { bus_id: 59,
        arrival_time: 944
      }
    )
  end

  it "solves for part 1" do
    expect(example.solve_part1).to eq 295
  end
end
