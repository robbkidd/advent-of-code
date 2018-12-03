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
        if levenshtein(first, second) == 1
          # assumes only one pair of box ids in the collection
          # have a one character difference in the same position
          return [first, second]
        end
      end
    end
  end

  # is it cheating if you know the name of a solution
  # but have to look up the implementation?
  def levenshtein(first, second)
    m, n = first.length, second.length
    return m if n == 0
    return n if m == 0
  
    d = Array.new(m+1) {Array.new(n+1)}
    0.upto(m) { |i| d[i][0] = i }
    0.upto(n) { |j| d[0][j] = j }
  
    1.upto(n) do |j|
      1.upto(m) do |i|
        d[i][j] = first[i-1] == second[j-1] ? d[i-1][j-1] : [d[i-1][j]+1,d[i][j-1]+1,d[i-1][j-1]+1,].min
      end
    end
    d[m][n]
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