require 'rspec'
require_relative '../lib/day08'

describe GameConsole do
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
end
