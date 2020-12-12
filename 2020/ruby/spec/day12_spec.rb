require 'rspec'
require_relative '../lib/day12'

describe "Day 12" do
end

describe Ship do
  it "follows the example directions" do
    example_ship = Ship.new(Day12.example_input)
    example_ship.follow_instructions
    expect(example_ship.distance_from_start).to eq 25
  end
end

describe ShipWithWaypoint do
  it "follows the example directions" do
    example_ship = ShipWithWaypoint.new(Day12.example_input)
    example_ship.follow_instructions
    expect(example_ship.distance_from_start).to eq 286
  end
end