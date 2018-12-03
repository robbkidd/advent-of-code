class Day2
  def self.part1
    box_ids = File.read('day02-input.txt').split("\n")
    BoxScanner.new.checksum(box_ids)
  end

  def self.part2
    box_ids = File.read('day02-input.txt').split("\n")
    bs = BoxScanner.new
    correct_box_ids = bs.off_by_one(box_ids)
    bs.common_characters(*correct_box_ids)
  end
end

class BoxScanner
  # PART 1
  def checksum(ids)
    doubles_count = 0
    triples_count = 0
    ids.each do |id|
      id_char_count = count_chars(id)
      doubles_count += 1 if id_char_count.values.include?(2)
      triples_count += 1 if id_char_count.values.include?(3)
    end
    doubles_count * triples_count
  end

  def count_chars(id)
    count = Hash.new(0)
    id.chars.each do |char|
      count[char] += 1
    end
    count
  end

  # PART 2
  def off_by_one(ids)
    ids.each do |first|
      ids.each do |second|
        if only_off_by_one?(first, second)
          # assumes only one pair of box ids in the collection
          # have a one character difference in the same position
          return [first, second]
        end
      end
    end
  end

  def only_off_by_one?(first, second)
    differences = 0
    first.chars.each_with_index do |char, index|
      differences += 1 if second[index] != char
      return false if differences > 1
    end
    differences == 1
  end

  def common_characters(first, second)
    common = []
    first.chars.each_with_index do |char, index|
      common << char if second[index] == char
    end
    common.join('')
  end
end

require 'rspec'

describe BoxScanner do
  it 'checksums' do
    box_ids = %w(abcdef bababc abbcde abcccd aabcdd abcdee ababab)
    expect(subject.checksum(box_ids)).to eq(12)
  end

  it 'off_by_one' do
    box_ids = %w(abcde fghij klmno pqrst fguij axcye wvxyz)
    expect(subject.off_by_one(box_ids)).to eq(%w(fghij fguij))
  end

  it 'common_characters' do
    expect(subject.common_characters('fghij', 'fguij')).to eq('fgij')
  end
end