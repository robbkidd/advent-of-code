class Day13
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: \n#{day.part2}"
  end

  attr_reader :input_dots, :input_folds, :papers, :fold_instructions

  # @example
  #   day.papers.first.to_s #=> Day13::EXAMPLE_DOTS
  #   day.fold_instructions.map(&:to_s) #=> ["y: 7", "x: 5"]
  def initialize(input=nil)
    @input_dots, @input_folds = (input || real_input).split("\n\n")

    @papers = [].push(Paper.new(@input_dots))

    @fold_instructions = @input_folds
      .split("\n")
      .map{ |line| line.split(" ").last.split("=") }
      .map{ |axis, line_number| FoldInstruction.new(axis, line_number) }
  end

  # @example
  #   day.part1 #=> 17
  def part1
    @papers.first.fold(@fold_instructions.first).dots.count
  end

  # @example
  #   day.part2 #=> Day13::EXAMPLE_FOLDED
  def part2
    @fold_instructions.each do |instruction|
      @papers << @papers.last.fold(instruction)
    end
    @papers.last.to_s
  end

  def parse_input(input)
    paper, instructions = input.split("\n\n")

    @folds = instructions

  end

  def real_input
    File.read('../inputs/day13-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
  INPUT

  EXAMPLE_DOTS = <<~DOTS
    ...#..#..#.
    ....#......
    ...........
    #..........
    ...#....#.#
    ...........
    ...........
    ...........
    ...........
    ...........
    .#....#.##.
    ....#......
    ......#...#
    #..........
    #.#........
  DOTS

  EXAMPLE_FOLDED = <<~DOTS
    #####
    #...#
    #...#
    #...#
    #####
  DOTS
end

# @example
#   fold = FoldInstruction.new("y", "7")
#   fold.axis #=> "y"
#   fold.line_number #=> 7
class FoldInstruction
  attr_reader :axis, :line_number
  def initialize(axis, line_number)
    @axis = axis
    @line_number = line_number.to_i
  end

  def fold(dot)
    case axis
    when "x" ; fold_up(dot)
    when "y" ; fold_left(dot)
    else ; raise "That's a weird axis you've got there. #{instruction}"
    end
  end

  def fold_up(dot)
    x, y = dot
    diff = x - line_number
    case
    when diff > 0 ; [line_number - diff, y]
    when diff < 0 ; dot
    else ; raise "That's a dot on a fold? #{self}"
    end
  end

  def fold_left(dot)
    x, y = dot
    diff = y - line_number
    case
    when diff > 0 ; [x, line_number - diff]
    when diff < 0 ; dot
    else ; raise "That's a dot on a fold? #{instruction}"
    end
  end

  def to_s
    "#{axis}: #{line_number}"
  end
end

class Paper
  attr_reader :dots

  # @example parses an incoming string for dots
  #   paper = Paper.new(day.input_dots)
  #   paper.dots #=> [[6,10],[0,14],[9,10],[0,3],[10,4],[4,11],[6,0],[6,12],[4,1],[0,13],[10,12],[3,4],[3,0],[8,4],[1,10],[2,14],[8,10],[9,0]]
  # @example accepts an array of dots
  #   paper = Paper.new([[1,1],[3,4]])
  #   paper.dots #=> [[1,1],[3,4]]
  def initialize(input)
    @dots = case input
            when String
              input
                .split("\n")
                .map{ |line|
                  line.split(",").map(&:to_i)
                }
            when Array
              input
            end
  end

  def fold(instruction)
    Paper.new(
      dots
        .map { |dot| instruction.fold(dot) }
        .uniq
    )
  end

  def to_s
    x_bounds,
    y_bounds = @dots
                .transpose
                .map{ |dimension| Range.new(*dimension.minmax) }

    y_bounds.map { |y|
      x_bounds.map { |x|
        if @dots.include?([x,y])
          "#"
        else
          "."
        end
      }.join
    }.join("\n")
    .concat("\n")
  end
end