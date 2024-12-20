require_relative 'day'
require 'fc' # FastContainers::PriorityQueue

class Day18 < Day # >
  attr_reader :memory_space_size, :start, :goal, :incoming_byte_positions, :first_bytes

  def initialize(input = nil, memory_space_size: 70, first_bytes: 1024)
    super(input)
    @memory_space_size = memory_space_size
    @first_bytes = first_bytes
    @start = [0, 0]
    @goal = [@memory_space_size, @memory_space_size]
    @incoming_byte_positions =
      @input
        .split("\n")
        .map { |line| line.scan(/(\d+)/).flatten.map(&:to_i) }
  end

  # @example
  #   day = new(EXAMPLE_INPUT, memory_space_size: 6, first_bytes: 12)
  #   day.part1 #=> 22
  def part1
    find_shortest_path_around_corrupted_memory(
      Set.new(incoming_byte_positions.take(first_bytes))
    ).count - 1
  end

  # @example
  #   day = new(EXAMPLE_INPUT, memory_space_size: 6, first_bytes: 12)
  #   day.part2 #=> "6,1"
  def part2
    low = first_bytes
    high = incoming_byte_positions.size
    result = nil

    while low <= high
      mid = (low + high) / 2
      path_to_exit = find_shortest_path_around_corrupted_memory(
        Set.new(incoming_byte_positions.take(mid))
      )

      if path_to_exit.empty?
        result = mid
        high = mid - 1
      else
        low = mid + 1
      end
    end

    incoming_byte_positions[result - 1].join(",")
  end

  def find_shortest_path_around_corrupted_memory(corrupted_memory)
    backsteps = Hash.new
    backsteps[start] = nil

    costs = Hash.new(Float::INFINITY)
    costs[start] = 0 # we start here, though, so it's cheap

    survey_queue = FastContainers::PriorityQueue.new(:min)
    survey_queue.push(start, 0)
    while !survey_queue.empty?
      check_pos = survey_queue.pop
      break if check_pos == goal

      [ [-1, 0] , [1, 0], [0, -1], [0, 1] ]
        .map { |offset| [check_pos[0] + offset[0], check_pos[1] + offset[1]] }
        .select { |neighbor| neighbor.all? { _1.between?(0, @memory_space_size) } }
        .each do |neighbor|
          neighbor_cost =
            costs[check_pos] + (corrupted_memory.include?(neighbor) ? Float::INFINITY : 1)

          if neighbor_cost < costs[neighbor]
            costs[neighbor] = neighbor_cost
            backsteps[neighbor] = check_pos

            survey_queue.push(neighbor, neighbor_cost)
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
    puts "\n" + debug(path, corrupted_memory) if ENV['DEBUG']
    path
  end

  def debug(path, corrupted_memory)
    (0..@memory_space_size)
      .map { |row|
        (0..@memory_space_size)
          .map { |column|
            coords = [column, row]
            if path.include?(coords)
              "\e[41m\e[1mO\e[0m"
            elsif corrupted_memory.include?(coords)
              "\e[31m#\e[0m"
            else
              "\e[32m.\e[0m"
            end
          }.join("")
        }.join("\n")
  end

  EXAMPLE_INPUT = File.read("../inputs/day18-example-input.txt")
end
