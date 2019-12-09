require 'rspec'
require_relative '../lib/day01'

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
