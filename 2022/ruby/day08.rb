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
  
    coords_from(r,c)
      .map { |coords_to_edge|
        coords_to_edge
          .map{ |coord| trees[coord] }
          .all? { |height| height < trees[[r,c]]}
      }.any? 
  end

  # @example
  #   day.coords_from(2,3) #=> []
  def coords_from(r,c)
    [
      (r-1).downto(row_bounds.min).map{ |row| [row, c] },    # to top
      (r+1).upto(row_bounds.max).map{ |row| [row, c] },      # to bottom
      (c-1).downto(column_bounds.min).map{ |col| [r, col] }, # to left
      (c+1).upto(column_bounds.max).map{ |col| [r, col] },   # to right
    ]
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
