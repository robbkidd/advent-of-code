class Guard
  attr_accessor :id, :shifts
  
end

class Shift
  def self.read_log

  end
end

class Note
  include Comparable

  attr_reader :timestamp, :entry

  def initialize(note)
    @timestamp, @entry = note.match(/\[(.*)\]\s(.*)/).captures
  end

  def <=>(other)
    self.timestamp <=> other.timestamp
  end

  def self.parse_wall(wall)
    wall.split("\n").map {|w| new(w)}
  end
end

require 'rspec'

describe Shift do
end

describe Note do
  it 'initializes from the stuff written on the wall' do
    note = described_class.new('[1518-02-28 00:47] falls asleep')
    expect(note.timestamp).to eq('1518-02-28 00:47')
    expect(note.entry).to eq('falls asleep')
  end

  it 'parses a wall into a collection of notes' do
    wall = <<~WALL
      [1518-02-28 00:47] falls asleep
      [1518-10-23 23:47] Guard #1627 begins shift
      [1518-10-25 00:41] wakes up
    WALL
    expect(described_class.parse_wall(wall)).to be_an Array 
  end

  it 'sorts a bunch of notes by timestamp' do
    wall = <<~SORT
      [1518-10-23 23:47] Guard #1627 begins shift
      [1518-02-28 00:47] falls asleep
      [1518-10-25 00:41] wakes up
    SORT
    notes = described_class.parse_wall(wall)
    sorted_timestamps = [
      '1518-02-28 00:47',
      '1518-10-23 23:47',
      '1518-10-25 00:41',
    ]
    expect(notes.sort.map(&:timestamp)).to eq(sorted_timestamps)
  end
end