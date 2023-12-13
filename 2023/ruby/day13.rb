require_relative 'day'

class Day13 < Day # >

  # @example
  #   day.part1 #=> 405
  def part1
    @patterns ||=
      input
        .split("\n\n")
        .map { |stanza| Pattern.new(stanza) }

    @patterns
      .map { |pattern| pattern.summarize }
      .reduce(&:+)
  end

  # example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
  INPUT

  FIRST_PATTERN = EXAMPLE_INPUT.split("\n\n").first
  SECOND_PATTERN = EXAMPLE_INPUT.split("\n\n").last
end

class Pattern
  attr_reader :rows, :columns

  # @example
  #   p = new(Day13::FIRST_PATTERN)
  #   p.rows.first #=> "#.##..##."
  #   p.columns.first #=> '#.##..#'
  def initialize(input)
    @input = input
    @rows = input.split("\n")
    @columns = @rows.map(&:chars).transpose.map(&:join)
  end

  # @example 1st
  #   p = new(Day13::FIRST_PATTERN)
  #   p.summarize #=> 5
  # @example 2nd
  #   p = new(Day13::SECOND_PATTERN)
  #   p.summarize #=> 400
  def summarize
    if row_reflection = line_of_reflection(rows)
      return row_reflection * 100
    end

    line_of_reflection(columns)
  end

  def row_reflection
    line_of_reflection(rows) *
    case reflection.length
    when 0
      return nil
    when 1
      return reflection.first[1] # the index of the second row in the line of reflection accounts for the 1-index of the puzzle
    else
      raise("more than one line of reflection for rows. wat?")
    end
  end

  # @example 1st_rows
  #   p = new(Day13::FIRST_PATTERN)
  #   p.line_of_reflection(p.rows) #=> nil
  # @example 1st_columns
  #   p = new(Day13::FIRST_PATTERN)
  #   p.line_of_reflection(p.columns) #=> 5
  # @example 2nd_rows
  #   p = new(Day13::SECOND_PATTERN)
  #   p.line_of_reflection(p.rows) #=> 4
  # @example 2nd_columns
  #   p = new(Day13::SECOND_PATTERN)
  #   p.line_of_reflection(p.columns) #=> nil
  def line_of_reflection(dimension)
    reflections ||=
      reflection_candidates(dimension)
        .select { |candidate|
          candidate[0].downto(0)
            .zip(candidate[1].upto(dimension.length-1))
            .select { |pair| pair.all? }
            .all? { |left, right| dimension[left] == dimension[right] }
        }
    case reflections.length
    when 0
      return nil
    when 1
      # account for the 1-index of the puzzle by returning the second index of a line of reflection
      return reflections.first[1]
    else
      raise("more than one line of reflection. wat?")
    end
  end

  # @example
  #   p = new(Day13::FIRST_PATTERN)
  #   p.reflection_candidates(p.rows) #=> [[2,3]]
  #   p.reflection_candidates(p.columns) #=> [[4,5]]
  def reflection_candidates(dimension)
      dimension
        .map.with_index
        .each_cons(2)
        .select { |left, right| left[0] == right[0] }
        .map { |left, right| [left[1], right[1]] }
  end

end
