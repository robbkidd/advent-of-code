class Day07
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = (input || real_input).chomp.split(",").map(&:to_i)
    @min, @max = @input.minmax
  end

  # @example
  #   d = Day07.new(EXAMPLE_INPUT)
  #   d.part1 #=> 37
  def part1
    avg = (@input.reduce(&:+) / @input.length).round

    candidates = avg
      .upto(@max)
      .to_a
      .zip(avg.downto(@min).to_a)
      .reject { |pair| pair.any? {|p| p.nil?} }
      .flatten
      .uniq

    candidates
      .map {|c|
        [ c ,fuel_cost_to_get_all_crabs_to(c) ]
      }
      .min_by {|position, fuel_cost| fuel_cost}[1]
  end

  def part2
  end

  def fuel_cost_to_get_all_crabs_to(position)
    @input
      .map { |i| (i - position).abs }
      .reduce(&:+)
  end

  def real_input
    File.read('../inputs/day07-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    16,1,2,0,4,2,7,1,2,14
  INPUT
end
