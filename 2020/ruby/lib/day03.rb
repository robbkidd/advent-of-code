class Day03
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    Toboggan.new(load_map).traverse(3, 1)
  end

  def self.part2
    Toboggan.new(load_map).try_slopes(slopes).reduce(:*)
  end

  def self.slopes
    [
      [1,1],
      [3,1],
      [5,1],
      [7,1],
      [1,2],
    ]
  end

  def self.load_map
    File.read('../inputs/day03-input.txt').split("\n")
  end
end

class Toboggan
  def initialize(tree_map)
    @tree_map = tree_map
  end

  def traverse(run, rise)
    (0..@tree_map.length-1).step(rise).each_with_index.inject(0) do |tree_strikes, (y,i)|
      row = @tree_map[y]
      x = (i * run) % row.length
      tree_strikes + ("#" == @tree_map[y][x] ? 1 : 0)
    end
  end

  def try_slopes(slopes = [[1,1]])
    slopes.map { |(run, rise)| traverse(run, rise) }
  end
end