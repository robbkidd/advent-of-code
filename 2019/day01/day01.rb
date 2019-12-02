class Day1
  def self.part1
    module_masses = File.read('day01-input.txt').split("\n")
    module_masses.map { |mass| ModuleV1.new(mass: mass.to_i) }.map(&:fuel_required).reduce(:+)
  end

  def self.part2
    module_masses = File.read('day01-input.txt').split("\n")
    module_masses.map { |mass| ModuleV2.new(mass: mass.to_i) }.map(&:fuel_required).reduce(:+)
  end
end

class ModuleV1
  attr_reader :mass

  def initialize(mass: 0)
    @mass = mass
  end

  def fuel_required
    (mass / 3).floor - 2
  end
end

class ModuleV2
  attr_reader :mass

  def initialize(mass: 0)
    @mass = mass
  end

  def fuel_required
    mass_to_fuel(mass)
  end

  private

  def mass_to_fuel(mass)
    fuel = (mass / 3).floor - 2
    if fuel > 0
      fuel += mass_to_fuel(fuel)
    else
      return 0
    end
  end
end

require 'rspec'

describe ModuleV1 do
  it 'example one' do
    subject = described_class.new(mass: 12)
    expect(subject.fuel_required).to eq(2)
  end

  it 'example two' do
    subject = described_class.new(mass: 14)
    expect(subject.fuel_required).to eq(2)
  end

  it 'example three' do
    subject = described_class.new(mass: 1969)
    expect(subject.fuel_required).to eq(654)
  end

  it 'example four' do
    subject = described_class.new(mass: 100756)
    expect(subject.fuel_required).to eq(33583)
  end
end

describe ModuleV2 do
  it 'example one' do
    subject = described_class.new(mass: 12)
    expect(subject.fuel_required).to eq(2)
  end

  it 'example two' do
    subject = described_class.new(mass: 14)
    expect(subject.fuel_required).to eq(2)
  end

  it 'example three' do
    subject = described_class.new(mass: 1969)
    expect(subject.fuel_required).to eq(966)
  end

  it 'example four' do
    subject = described_class.new(mass: 100756)
    expect(subject.fuel_required).to eq(50346)
  end
end
