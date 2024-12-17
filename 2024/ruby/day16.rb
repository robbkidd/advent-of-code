require_relative 'day'
require_relative 'grid'
require 'set'

class Day16 < Day # >
  attr_reader :start, :goal, :map

  def initialize(*args)
    super
    @start = nil
    @goal = nil
    @minimum_score = nil
    @visited = Set.new
    @map =
      Grid
        .new(input)
        .parse { |coords, value|
          case value
          when 'S' ; @start = coords
          when 'E' ; @goal = coords
          end
        }
  end

  # @example
  #   day.part1 #=> 7036
  # @example two
  #   day = new(EXAMPLE_TWO)
  #   day.part1 #=> 11048
  # @example rando
  #  day = new(EXAMPLE_RANDO)
  #  day.part1 #=> 4013
  def part1
    # backsteps = Hash.new
    # backsteps[[start, nil]] = nil

    # costs = Hash.new(Float::INFINITY)
    # costs[start] = 0

    # survey_queue = FastContainers::PriorityQueue.new(:min)
    # survey_queue.push([start,[0,1]], 0)
    # while !survey_queue.empty?
    #   check_pos, facing = survey_queue.pop
    #   break if check_pos == goal

    #   map.neighbors_and_directions_for(check_pos).each do |direction, neighbor|
    #     neighbor_cost = costs[check_pos] + (
    #       if map.at(neighbor) == '#'
    #         Float::INFINITY
    #       elsif direction == facing
    #         1
    #       else
    #         1001
    #       end
    #     )

    #     if neighbor_cost < costs[neighbor]
    #       costs[neighbor] = neighbor_cost
    #       backsteps[neighbor] = check_pos

    #       survey_queue.push([neighbor, direction], neighbor_cost)
    #     end
    #   end
    # end

    # path = []
    # if backsteps.include?(goal)
    #   path.push(goal)
    #   step_backwards = backsteps[goal]
    #   while step_backwards
    #     path.push(step_backwards)
    #     step_backwards = backsteps[step_backwards]
    #   end
    # end

    @minimum_score ||=
      find_lowest_score_path
        .tap { |_score, path|
          @visited.merge(path)

          if ENV['DEBUG']
            puts map.to_s {|coords, value|
              next value if value == 'S' || value == 'E'
              next "+" if path.include?(coords)
              value
            }
          end
        }.first
  end

  # @example
  #   day.part2 #=> 45
  # @example two
  #   day = new(EXAMPLE_TWO)
  #   day.part2 #=> 64
  def part2
    part1
    visited_length = @visited.count
    loop do
      score, path = find_lowest_score_path
      puts [score,path].inspect if ENV['DEBUG']

      @visited.merge(path)
      if visited_length == @visited.count
        break
      else
        visited_length = @visited.count
      end
    end

    if ENV['DEBUG']
      puts map.to_s {|coords, value|
        @visited.include?(coords) ? "\e[1mO\e[0m" : value
      }
    end

    @visited.count
  end

  def find_lowest_score_path
    backsteps = Hash.new
    backsteps[start] = nil

    costs = Hash.new(Float::INFINITY)
    costs[start] = 0

    survey_queue = FastContainers::PriorityQueue.new(:min)
    survey_queue.push([start,[0,1]], 0)
    while !survey_queue.empty?
      check_pos, facing = survey_queue.pop
      break if check_pos == goal

      map.neighbors_for(check_pos).each do |direction, neighbor|
        neighbor_cost = costs[check_pos] + (
          if map.at(neighbor) == '#'
            Float::INFINITY
          elsif direction == facing
            1
          else
            @visited.include?([neighbor, check_pos]) ? 1002 : 1001
          end
        )

        if neighbor_cost < costs[neighbor]
          costs[neighbor] = neighbor_cost
          backsteps[neighbor] = check_pos

          survey_queue.push([neighbor, direction], neighbor_cost)
        end
      end
    end

    path = []
    if backsteps.include?(goal)
      path.push(goal)
      step_backwards = backsteps[goal]
      while step_backwards
        path.push(step_backwards)
        step_backwards = backsteps[step_backwards]
      end
    end

    [ costs[goal], path ]
  end

  EXAMPLE_INPUT = <<~ONE
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
  ONE

  EXAMPLE_TWO = <<~TWO
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
  TWO

  EXAMPLE_RANDO = <<~RANDO
    ##########
    #.......E#
    #.##.#####
    #..#.....#
    ##.#####.#
    #S.......#
    ##########
  RANDO
end
