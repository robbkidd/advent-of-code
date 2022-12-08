class Day08
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input, :trees, :row_bounds, :column_bounds

  def initialize(input=nil)
    @input = input || real_input
    @trees = Hash.new(:out_of_bounds)
    parse_input
  end

  # @example
  #   day.part1 #=> 21
  def part1
    trees
      .select { |coord, _height| visible?(*coord) }
      .count
  end

  def part2
  end

  # @example
  #   day.visible?(2,3) #=> true
  def visible?(r,c)
    return true if row_bounds.minmax.include?(r) || column_bounds.minmax.include?(c)
  
    [
      (row_bounds.min..r-1).map{ |row| [row, c] },    # from top
      (r+1..row_bounds.max).map{ |row| [row, c] },    # from bottom
      (column_bounds.min..c-1).map{ |col| [r, col] }, # from left
      (c+1..column_bounds.max).map{ |col| [r, col] }, # from right
    ].map { |coords_to_edge|
      coords_to_edge
        .map{ |coord| trees[coord] }
        .all? { |height| height < trees[[r,c]]}
    }.any? 
  end

  # @example
  #   day.parse_input
  #   day.row_bounds #=> 0..4
  #   day.column_bounds #=> 0..4
  def parse_input
    @input
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index{ |row, r|
        row.each_with_index{ |tree_height, c|
          trees[[r,c]] = tree_height
        }
      }

      @row_bounds,
      @column_bounds = trees
        .keys
        .transpose
        .map{ |dimension| Range.new(*dimension.minmax) }
  end

  def real_input
    File.read('../inputs/day08-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    30373
    25512
    65332
    33549
    35390
  INPUT
end
