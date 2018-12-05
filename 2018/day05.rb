class Day05
  def self.part1
    input = File.read('day04-input.txt').chomp
    Polymer.new.react(input).size
  end

  def self.part2
    input = File.read('day04-input.txt').chomp
    Polymer.new.most_improved(input).size
  end
end

class Polymer
  def react(polymer)
    chunks = chunks(polymer)
    
    if !reactable?(chunks)
      polymer
    else
      react(chunks.map{ |e| e.length.odd? ? e[0] : '' }.join(''))
    end
  end

  # this redditer's https://www.reddit.com/r/adventofcode/comments/a3912m/2018_day_5_solutions/eb4digq/
  # gsubbing was faster
  def faster_react(str)
    loop {
      break if (?a..?z).all? { |x|
        [
          str.gsub!("#{x}#{x.upcase}", ''),
          str.gsub!("#{x.upcase}#{x}", ''),
        ].none?
      }
    }
    str
  end

  def most_improved(polymer)
    ('a'..'z').map { |unit| react(polymer.tr("#{unit}#{unit.upcase}", '').size) }.min
  end

  def chunks(polymer)
    polymer.chars.chunk_while {|p, n| p == n.swapcase}.to_a 
  end

  def reactable?(polymer_chunks)
    polymer_chunks.any?{|e| e.length > 1}
  end
end

# still no tests, it's late