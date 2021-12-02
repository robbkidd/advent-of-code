class Day10
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    chain = AdapterChain.new
    chain.joltage_distribution
         .values
         .reduce(:*)
  end

  def part2
  end

  def self.example_input_1
    <<~EXAMPLE
      16
      10
      15
      5
      1
      11
      7
      19
      6
      12
      4
    EXAMPLE
  end

  def self.example_input_2
    <<~EXAMPLE
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
    EXAMPLE
  end
end

class AdapterChain
  attr_reader :adapters

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day10-input.txt"))
               .split("\n")
               .map(&:to_i)
    @adapters = @input.sort
    @adapters.unshift(0)
    @adapters << @adapters[-1] + 3
  end

  def joltage_distribution
    joltage_differences.inject(Hash.new(0)) { |h, diff| h[diff] += 1 ; h }
  end

  def joltage_differences
    adapters.each_cons(2)
            .map { |p,n| n-p }
  end

  def number_of_arrangements
    traverse_node(tree, {}, 0)
  end

  def tree
    tree = adapters.each_with_index
                   .inject({}) do |h, (adapter, idx)|
                      next3 = adapters[idx+1..idx+3]
                      h[adapter] = next3.select{ |a| a <= adapter+3 }
                      h
                   end
  end

  def traverse_node(nodes, cache, start)
    puts start
    count = 0
    children = nodes[start]
    if cache[start]
      return cache[start]
    elsif children.empty?
      count += 1
    else
      children.each { |child| count += traverse_node(nodes, cache, child) }
    end
  
    puts "#{start}, #{count}"

    cache[start] = count
    return count
  end
end