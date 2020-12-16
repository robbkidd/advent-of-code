class Day15
  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    MemoryGame.new([2,0,1,9,5,19]).spoken_at_round(2020)
  end

  def part2
    # it takes 30 seconds ... don't even care
    MemoryGame.new([2,0,1,9,5,19]).spoken_at_round(30_000_000)
  end

  def self.example_input
    <<~EXAMPLE
    EXAMPLE
  end

  def self.example_input2
    <<~EXAMPLE
    EXAMPLE
  end
end

class MemoryGame
  def initialize(starting_numbers)
    @starting_numbers = starting_numbers
    @last_spoken = starting_numbers[-1]
    @last_spoke_at = Hash.new { |hash, key| hash[key] = Array.new }
    starting_numbers.each_with_index do |num, idx|
      @last_spoke_at[num] = @last_spoke_at[num].prepend(idx+1)
    end
  end

  def spoken_at_round(stopping_round)
    (@starting_numbers.length+1..stopping_round).each do |round|
      if @last_spoke_at[@last_spoken].length > 1
        @last_spoken = @last_spoke_at[@last_spoken][0..1].reduce(&:-)
      else
        @last_spoken = 0
      end
      @last_spoke_at[@last_spoken] = @last_spoke_at[@last_spoken].prepend(round)
    end
    @last_spoken
  end
end