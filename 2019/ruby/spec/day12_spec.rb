require 'rspec'
require_relative '../lib/day12'

describe Moon do
  context 'part 1' do
    it 'example one' do
      moons = Moon.parse_input(Day12::EXAMPLE1)
      Moon.step_time(moons, 10)
      expect(moons.map(&:total_energy).reduce(&:+)).to eq(179)
    end

    it 'example two' do
      moons = Moon.parse_input(Day12::EXAMPLE2)
      Moon.step_time(moons, 100)
      expect(moons.map(&:total_energy).reduce(&:+)).to eq(1940)
    end
  end
end
