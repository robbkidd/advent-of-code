class Day08
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input, :forest

  def initialize(input=nil)
    @input = input || real_input
    @forest = Forest.new(@input)
  end

  # @example
  #   day.part1 #=> 21
  def part1
    forest
      .trees
      .select{ |_, tree| tree.visible }
      .count
  end

  # @example
  #   day.part2 #=> 8
  def part2
    forest
      .trees
      .map {|_, tree| tree.scenic_score }
      .max
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

Tree = Struct.new(:coord, :height, :forest) do
  def visible
    @visible ||= forest.tree_visible_from_edge?(self)
  end

  def scenic_score
    @scenic_score ||= forest.scenic_score(self)
  end
end

class Forest
  attr_reader :trees, :row_bounds, :column_bounds

  def initialize(input)
    @input = input
    @trees = Hash.new(:out_of_bounds)
    populate
  end

  # @example when on the edge
  #   forest = Forest.new(day.input)
  #   forest.tree_visible_from_edge?([0,0]) #=> true
  #
  # @example when visible in the midst
  #   forest = Forest.new(day.input)
  #   tree = forest.tree_at([3,2])
  #   forest.tree_visible_from_edge?(tree) #=> true
  #   tree.visible                         #=> true
  def tree_visible_from_edge?(tree)
    tree = coerce_to_tree(tree)

    on_edge?(tree) ||
      coords_in_cardinal_directions_from(tree)
        .map { |coords_in_a_direction_to_edge|
          coords_in_a_direction_to_edge
            .map{ |coord| tree_at(coord).height } # collect all the heights in this direction
            .all? { |other_height| other_height < tree.height} # are all heights in this direction less than current tree?
        }.any? # tree visible from the edge in any of the directions?
  end

  # @example ok
  #   forest = Forest.new(day.input)
  #   tree = forest.tree_at([1,2])
  #   forest.scenic_score(tree) #=> 4
  #   tree.scenic_score         #=> 4
  #
  # @example better
  #   forest = Forest.new(day.input)
  #   tree = forest.tree_at([3,2])
  #   forest.scenic_score(tree) #=> 8
  #   tree.scenic_score         #=> 8
  def scenic_score(tree)
    tree = coerce_to_tree(tree)

    coords_in_cardinal_directions_from(tree)
      .map { |coords_in_a_direction_to_edge|
          other_trees = coords_in_a_direction_to_edge.map{ |coord| tree_at(coord) } # collect all the trees in this direction
          view = []
          blocked = false
          while (other_tree = other_trees.shift) && !blocked do
            view << other_tree
            blocked = true if other_tree.height >= tree.height
          end
          view.count
        }
        .reduce(&:*)
  end

  # @example
  #   forest = Forest.new(day.input)
  #   tree = forest.tree_at([3,2])
  #   tree.coord #=> [3,2]
  #   tree.height #=> 5
  def tree_at(coord)
    @trees[coord]
  end

  # @example
  #   forest = Forest.new(day.input)
  #   forest.on_edge?([3,2]) #=> false
  #   forest.on_edge?([0,0]) #=> true
  def on_edge?(tree)
    r,c = coerce_to_tree(tree).coord
    row_bounds.minmax.include?(r) || column_bounds.minmax.include?(c)
  end

  def coords_in_cardinal_directions_from(tree)
    r,c = coerce_to_tree(tree).coord
    [
      (r-1).downto(row_bounds.min).map{ |row| [row, c] },    # to top
      (r+1).upto(row_bounds.max).map{ |row| [row, c] },      # to bottom
      (c-1).downto(column_bounds.min).map{ |col| [r, col] }, # to left
      (c+1).upto(column_bounds.max).map{ |col| [r, col] },   # to right
    ]
  end

  def coerce_to_tree(something_treeish)
    case something_treeish
    when Array ; tree_at(something_treeish)
    when Tree ; something_treeish
    else
      :lolwut_is_that
    end
  end

  # @example
  #   forest = Forest.new(day.input)
  #   forest.row_bounds #=> 0..4
  #   forest.column_bounds #=> 0..4
  def populate
    @input
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index{ |row, r|
        row.each_with_index{ |tree_height, c|
          @trees[[r,c]] = Tree.new([r,c], tree_height, self)
        }
      }

    @row_bounds,
    @column_bounds = @trees
                      .keys
                      .transpose
                      .map{ |dimension| Range.new(*dimension.minmax) }
  end
end