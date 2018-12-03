class Day1
  def self.part1
    frequency_changes = File.read('day01-input.txt').split("\n")
    FrequencyStabilizer.new.stabilize(frequency_changes)
  end

  def self.part2
    frequency_changes = File.read('day01-input.txt').split("\n")
    FrequencyStabilizer.new.stabilize_dupes(frequency_changes)
  end
end

class FrequencyStabilizer
  def stabilize(input)
    input.map(&:to_i).reduce(&:+)
  end

  def stabilize_dupes(input)
    frequency_changes = input.map(&:to_i)
    new_frequency = 0
    frequencies_seen = { new_frequency => true }
    first_duplicate = nil
    until first_duplicate
      frequency_changes.each do |change|
        new_frequency += change
        if frequencies_seen[new_frequency]
          first_duplicate = new_frequency
          break
        else
          frequencies_seen[new_frequency] = true
        end
      end
    end
    first_duplicate
  end
end

require 'rspec'

describe FrequencyStabilizer do
  context 'part1' do
    it 'example one' do
      frequency_changes = %w(+1 -2 + 3 +1)
      expect(subject.stabilize(frequency_changes)).to eq(3)
    end

    it 'example two' do
      frequency_changes = %w(+1 +1 +1)
      expect(subject.stabilize(frequency_changes)).to eq(3)
    end

    it 'example three' do
      frequency_changes = %w(+1 +1 -2)
      expect(subject.stabilize(frequency_changes)).to eq(0)
    end

    it 'example four' do
      frequency_changes = %w(-1 -2 -3)
      expect(subject.stabilize(frequency_changes)).to eq(-6)
    end
  end

  context 'part2' do
    examples = [
      [%w(+1 -2 +3 +1), 2],
      [%w(+1 -1), 0],
      [%w(+3 +3 +4 -2 -4), 10],
      [%w(-6 +3 +8 +5 -6), 5],
      [%w(+7 +7 -2 -7 -4), 14]
    ].each do |inputs, final_frequency|
      it "#{inputs} ends on #{final_frequency}" do
        expect(subject.stabilize_dupes(inputs)).to eq(final_frequency)
      end
    end
  end
end