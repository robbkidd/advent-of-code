require 'rspec'
require_relative '../lib/day14'

describe SeaPortComputer do
  it "sets the current mask" do
    computer = described_class.new(Day14.example_input)
    computer.set_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
    expect(computer.mask).to eq({
      29 => "1",
      34 => "0"
    })
  end

  it "sets memory based on the current mask" do
    computer = described_class.new(Day14.example_input)
    computer.set_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
    computer.set_mem([8, 11])
    expect(computer.memory[8]).to eq 73
  end

  it "runs the example program" do
    computer = described_class.new(Day14.example_input)
    computer.program_init
    expect(computer.memory[8]).to eq 64
    expect(computer.memory[7]).to eq 101
    expect(computer.check_sum).to eq 165
  end
end

describe SeaPortComputerV2 do
  it "sets the current mask" do
    computer = described_class.new(Day14.example_input2)
    computer.set_mask("000000000000000000000000000000X1001X")
    expect(computer.mask).to eq("000000000000000000000000000000X1001X")
  end

  it "sets memory based on the current mask" do
    computer = described_class.new(Day14.example_input2)
    computer.set_mask("000000000000000000000000000000X1001X")
    computer.set_mem([42, 100])
    expect(computer.memory[26]).to eq 100
    expect(computer.memory[27]).to eq 100
    expect(computer.memory[58]).to eq 100
    expect(computer.memory[59]).to eq 100
  end

  it "sets memory based on a different mask" do
    computer = described_class.new(Day14.example_input2)
    computer.set_mask("00000000000000000000000000000000X0XX")
    computer.set_mem([26, 1])
    expect(computer.memory[16]).to eq 1
    expect(computer.memory[17]).to eq 1
    expect(computer.memory[18]).to eq 1
    expect(computer.memory[19]).to eq 1
    expect(computer.memory[24]).to eq 1
    expect(computer.memory[25]).to eq 1
    expect(computer.memory[26]).to eq 1
    expect(computer.memory[27]).to eq 1
  end

  it "runs the example program" do
    computer = described_class.new(Day14.example_input2)
    computer.program_init
    expect(computer.check_sum).to eq 208
  end
end