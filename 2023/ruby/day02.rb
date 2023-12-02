require_relative 'day'

class Day02 < Day # >

  # @example
  #   day.part1 #=> 8
  def part1
    input
      .split("\n")
      .each_with_object({}) { |line, record|
        game_id, sets = parse(line)
        record[game_id] = sets
      }
      .reject { |_game_id, sets|
        sets.map { |set|
          set.fetch(:red, 0) > 12 ||
            set.fetch(:green, 0) > 13 ||
            set.fetch(:blue, 0) > 14
        }.any?
      }
      .keys
      .reduce(:+)
  end

  # @example
  #   day.part2 #=> 2286
  def part2
    input
      .split("\n")
      .each_with_object({}) { |line, record|
        game_id, sets = parse(line)
        record[game_id] = sets
      }
      .map { |_game_id, sets|
        sets.reduce { |memo, set|
          [:red, :green, :blue].each do |color|
            memo[color] = [memo.fetch(color, 0), set.fetch(color, 0)].max
          end
          memo
        }
      }
      .map { |color_minimums|
        color_minimums
          .values
          .reduce(:*)
      }
      .reduce(:+)
  end

  # @example
  #   day.parse('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green') #=> [1, [{blue: 3, red: 4}, {red: 1, green: 2, blue: 6}, {green: 2}]]
  def parse(line)
    id, sets = line.split(': ')
    id = id.slice(/\d+$/).to_i

    sets = sets
      .split('; ')
      .map { |set|
        set
          .split(", ")
          .map { |cubes|
            count, color = cubes.split(" ")
            [color.to_sym, count.to_i]
          }.to_h
      }

    [id, sets]
  end

  EXAMPLE_INPUT = <<~INPUT
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  INPUT
end
