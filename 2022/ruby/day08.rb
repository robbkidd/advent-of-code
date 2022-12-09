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
  include Comparable

  def <=>(other)
    height <=> other.height
  end

  def visible
    @visible ||= 
      ( forest.on_edge?(self) || 
          other_trees_in_cardinal_directions
            .map { |_dir, trees| trees.all? { |other| other < self } } # am I visible in that direction?
            .any? # am I visible in any direction?
      ) 
  end

  def other_trees_in_cardinal_directions
    @other_trees_in_cardinal_directions ||= forest.trees_in_cardinal_directions_from(self)
  end

  def scenic_score
    @scenic_score ||= scenic_view.map(&:count).reduce(&:*)
  end

  # @example ok
  #   forest = Forest.new(day.input)
  #   tree = forest.tree_at([1,2])
  #   tree.scenic_view.map(&:count) #=> [1, 2, 1, 2]
  #
  # @example better
  #   forest = Forest.new(day.input)
  #   tree = forest.tree_at([3,2])
  #   tree.scenic_view.map(&:count) #=> [2, 1, 2, 2]
  def scenic_view
    @scenic_view ||=
      other_trees_in_cardinal_directions
        .map { |_dir, trees|
          blocked = false
          trees
            .each_with_object([]) {|other_tree, view|
              if !blocked
                view << other_tree
                blocked = true if other_tree >= self
              end
            }
        }
  end
end

class Forest
  attr_reader :trees, :row_bounds, :column_bounds

  def initialize(input)
    @trees = Hash.new(:out_of_bounds)
    populate(input)
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

  # @example
  #   forest = Forest.new(day.input)
  #   nsew_trees = forest.trees_in_cardinal_directions_from([3,2])
  #   nsew_trees.values.map{|dir_trees| dir_trees.map(&:coord) } #=> [[[2, 2], [1, 2], [0, 2]], [[4, 2]], [[3, 1], [3, 0]], [[3, 3], [3, 4]]]
  def trees_in_cardinal_directions_from(tree)
    r,c = coerce_to_tree(tree).coord
    {
      to_top:    (r-1).downto(row_bounds.min)    .map{ |row| tree_at([row, c]) },
      to_bottom: (r+1).upto(row_bounds.max)      .map{ |row| tree_at([row, c]) },
      to_left:   (c-1).downto(column_bounds.min) .map{ |col| tree_at([r, col]) }, 
      to_right:  (c+1).upto(column_bounds.max)   .map{ |col| tree_at([r, col]) },
    }
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
  def populate(input)
    input
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

  def to_s
    "a forest (#{self.object_id})"
  end
end