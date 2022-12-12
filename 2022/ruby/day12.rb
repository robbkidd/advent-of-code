require_relative 'day'

Signal.trap("INT") {
  puts "\nInterrupt! Stopping."
  exit
}

class Day12 < Day # >

  # @example
  #   day.part1 #=> 31
  def part1
    algo = HillClimbingAlgorithm.new(input)
    path = algo.shortest_path_to_goal
    path.length - 1 # don't include start
  end

  # @examples
  #   day.part2
  def part2
  end

  EXAMPLE_INPUT = <<~INPUT
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
  INPUT
end

class HillClimbingAlgorithm
  require "fc"

  attr_reader :grid, :start, :goal

  def initialize(input=nil)
    @grid  = Hash.new { |(r,c)| :out_of_bounds }
    @start = :unknown_start
    @goal  = :unknown_goal

    parse_input(input)

    @row_bounds,
    @column_bounds = @grid
                      .keys
                      .transpose
                      .map{ |dimension| Range.new(*dimension.minmax) }
  end

  def shortest_path_to_goal
    backsteps = { start.coords => nil }
    steps = { start.coords => 0 }
    steps.default = Float::INFINITY

    survey_queue = FastContainers::PriorityQueue.new(:min)
    survey_queue.push(start.coords, 0)
    while (check_coords = survey_queue.pop) do
      check_hill = grid[check_coords]
      break if check_hill.goal?

      check_hill
        .adjacent_coords
        .map { |neighbor_coords| grid[neighbor_coords] }
        .reject { |other| other == :out_of_bounds }
        .filter { |other_hill| check_hill.diff(other_hill) <= 1 }
        .each do |hikable_hill|
          neighbor_steps = steps[check_hill.coords] + 1
          if neighbor_steps < steps[hikable_hill.coords]
            steps[hikable_hill.coords] = neighbor_steps
            backsteps[hikable_hill.coords] = check_hill.coords

            weight = neighbor_steps
            survey_queue.push(hikable_hill.coords, weight)
          end
        end
    end

    path = [goal.coords]
    previous_coords = backsteps[goal.coords]
    while previous_coords do
      path.push(previous_coords)
      previous_coords = backsteps[previous_coords]
    end
    path
  end

  # @example
  #   algo = new(Day12::EXAMPLE_INPUT)
  #   algo.grid.class                      #=> Hash
  #   algo.start.coords                    #=> [0,0]
  #   algo.goal.coords                     #=> [2,5]
  #   algo.grid.fetch([0,0]).start?        #=> true
  #   algo.grid.fetch([0,0]) == algo.start #=> true
  #   algo.grid.fetch([2,5]).goal?         #=> true
  #   algo.grid.fetch([2,5]) == algo.goal  #=> true
  def parse_input(str='')
    str
      .split("\n")
      .map{|row| row.chars}
      .each_with_index { |row, r|
        row.each_with_index{ |encoded_elevation, c|
          coords = [r,c]
          hill = Hill.new(encoded_elevation, coords)
          @grid[coords] = hill
          if hill.start? ; start == :unknown_start ? @start = hill : raise("Uh. We already found a start.") ; end
          if hill.goal?  ; goal  == :unknown_goal  ? @goal  = hill : raise("Uh. We already found a goal.")  ; end
        }
      }
  end
end

class Hill
  def initialize(encoded_elevation, coords=:unknown_coords)
    @coords = coords
    @neighbors = []
    @encoded_elevation = encoded_elevation
    @elevation =  case @encoded_elevation
                  when 'S' ; ('a'.ord - 1)
                  when 'E' ; ('z'.ord + 1)
                  when /\A[a-z]\z/ ; @encoded_elevation.ord
                  else raise "Your map looks funny. What's a '#{encoded_elevation}'?"
                  end
  end


  attr_reader :elevation
  def start? ; @start ||= @encoded_elevation == 'S' ; end
  def goal?  ; @goal  ||= @encoded_elevation == 'E' ; end

  def diff(other) ; other.elevation - elevation           ; end

  def to_s ; @encoded_elevation ; end

  # @example
  #   hill = new('k', [10, 20])
  #   hill.adjacent_coords #=> [ [9,20] , [11,20] , [10, 19] , [10, 21] ]
  attr_reader :coords
  def adjacent_coords
    @adjacent_coords ||=
      OFFSET_TO_DIRECTION.keys
        .map { |offset|
          coords
            .zip(offset)
            .map {|p| p.reduce(&:+)}
        }
  end

  def direction_to(other)
    # use fetch to throw exception if other is not adjacent
    OFFSET_TO_DIRECTION.fetch(offset_to(other))
  end

  def offset_to(other)
    [
      other.coords[0] - coords[0],
      other.coords[1] - coords[1],
    ]
  end

  OFFSET_TO_DIRECTION = {
    # r   c
    [-1,  0] => '^', # up a row
    [ 1,  0] => 'v', # down a row
    [ 0, -1] => '<', # left a column
    [ 0,  1] => '>', # right a column
  }
end
