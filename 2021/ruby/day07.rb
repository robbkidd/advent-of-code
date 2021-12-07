class Day07
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = (input || real_input).chomp.split(",").map(&:to_i)
    @min, @max = @input.minmax
    @avg = (@input.reduce(&:+) / @input.length).round
  end

  # @example
  #   d = Day07.new(EXAMPLE_INPUT)
  #   d.part1 #=> [2, 37]
  def part1
    likely_candidates
      .map {|c|
        [ c , naive_fuel_cost_to_get_all_crabs_to(c) ]
      }
      .min_by {|position, fuel_cost| fuel_cost}
  end

  # @example
  #   d = Day07.new(EXAMPLE_INPUT)
  #   d.part2 #=> [5, 168]
  def part2
    likely_candidates
      .map {|c|
        [ c , crab_engineering_fuel_cost_to_get_all_crabs_to(c) ]
      }
      .min_by {|position, fuel_cost| fuel_cost}
  end

  def likely_candidates
    @candidates ||=
      @avg
        .upto(@max)
        .to_a
        .zip(@avg.downto(@min).to_a)
        .reject { |pair| pair.any? {|p| p.nil?} }
        .flatten
        .uniq
  end

  def naive_fuel_cost_to_get_all_crabs_to(position)
    @input
      .map { |i| (i - position).abs } # distance
      .reduce(&:+)
  end

  def crab_engineering_fuel_cost_to_get_all_crabs_to(position)
    @input
      .map { |i|
        d = (i - position).abs # distance
        d * (d+1) / 2 # fuel_cost
      }
      .reduce(&:+)
  end

  def real_input
    File.read('../inputs/day07-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    16,1,2,0,4,2,7,1,2,14
  INPUT
end
