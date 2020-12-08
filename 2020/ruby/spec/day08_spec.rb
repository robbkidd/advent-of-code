require 'rspec'
require_relative '../lib/day08'

describe "Day 8" do
  let(:example_code) {
    <<~EXAMPLE
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
    EXAMPLE
  }

  it "parses the example input" do
    console = GameConsole.new(example_code)
    example_boot_code = console.parse(example_code)
    expect(example_boot_code.first).to eq GameConsole::InStruction.new("nop", "+0")
    expect(example_boot_code.last).to eq GameConsole::InStruction.new("acc", "+6")
  end

  it "detects an infinite loop" do
    console = GameConsole.new(example_code)
    expect{console.run}.to raise_error(GameConsole::InfiniteLoopError, "accumulated 5")
  end

  it "returns the accumulator value when there is no loop" do
    console = GameConsole.new(example_code)
    console.patch_at(7)
    expect(console.run).to eq 8
  end

  it "finds all the nop and jmp indexes" do
    day = Day08.new(example_code)
    expect(day.patch_sites).to eq []
  end
end
