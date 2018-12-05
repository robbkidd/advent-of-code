class Day04
  attr_reader :wall
  def initialize
    @wall = Wall.parse_and_prep(File.read('day04-input.txt'))
    wall.process
  end

  def part1
    sleepiest_guard = Guard.slept_the_most(wall.guards.values)
    guards_sleepiest_minute = sleepiest_guard.minute_most_frequently_asleep.first
    { sleepiest_guard_id: sleepiest_guard.id,
      guards_sleepiest_minute: guards_sleepiest_minute,
      answer: sleepiest_guard.id.to_i * guards_sleepiest_minute
    }
  end

  def part2
    id, minute_frequency = Guard.frequently_asleep_on_the_same_minute(wall.guards.values)
    minute, frequency = minute_frequency
    { guard: id,
      minute: minute,
      frequency: frequency,
      answer: id.to_i * minute
    }
  end
end

class Wall
  attr_reader :notes, :guards

  def self.parse_and_prep(wall)
    new(wall.split("\n").map {|w| Note.new(w)}.sort)
  end

  def initialize(notes)
    @notes = notes
    @guards = Hash.new {|hash, key| hash[key] = Guard.new(key)}
  end

  def process
    current_guard = nil
    notes.each_cons(2) do |current_note, next_note|
      case current_note.entry
      when /Guard #(\d*) begins shift/
        current_guard = guards[$1]
      when /falls asleep/
        raise 'WAT' if !next_note.entry.match(/wakes up/)
        asleep = current_note.minute
        awake = next_note.minute
        current_guard.total_time_asleep += (awake - asleep)

        current_guard.minute_popularity ||= Hash.new(0)
        (asleep...awake).each do |minute|
          current_guard.minute_popularity[minute] += 1
        end
      end
    end
  end
end

class Note
  include Comparable

  attr_reader :entry, :minute, :timestamp

  def initialize(note)
    @original = note
    @timestamp, @entry = note.match(/\[(.*)\]\s(.*)/).captures
    @minute = timestamp.split(':')[1].to_i
  end

  def <=>(other)
    self.timestamp <=> other.timestamp
  end

  def minute
    timestamp.split(':')[1].to_i 
  end

  def to_s
    @original
  end
end

class Guard
  attr_accessor :id, :total_time_asleep, :minute_popularity
  def initialize(id)
    @id = id
    @total_time_asleep = 0
    @minute_popularity = Hash.new(0)
  end

  def to_s
    { id: id,
      total_time_asleep: total_time_asleep,
      minute_popularity: minute_popularity,
    }.to_s
  end

  def minute_most_frequently_asleep
    return nil if minute_popularity.empty?
    minute_popularity.max_by{|minute, frequency| frequency}
  end

  def self.slept_the_most(guards)
    guards.max_by{|g| g.total_time_asleep}
  end

  def self.frequently_asleep_on_the_same_minute(guards)
    guards.map{ |g| [g.id, g.minute_most_frequently_asleep] }
          .reject{ |id,minute_freq| minute_freq.nil? }
          .max_by{ |id,minute_freq| minute_freq[1] }
  end
end

# no tests, this was RELP-driven development