require_relative 'day'

class Day02 < Day # >

  # @example
  #   day.part1 #=> 8
  def part1
    input
      .split("\n")
      .each_with_object({}) { |line, record| # create the record of the games
        game_id, sets = parse(line)
        record[game_id] = sets
      }
      .reject { |_game_id, sets|             # reject any game wherein ...
        sets.any? { |set|                    # any set has too many of a color
          set[:red] > 12 ||
            set[:green] > 13 ||
            set[:blue] > 14
        }
      }
      .keys                                  # consider only the game IDs
      .reduce(:+)                            # and add them up
  end

  # @example
  #   day.part2 #=> 2286
  def part2
    input
      .split("\n")
      .each_with_object({}) { |line, record| # create the record of the games
        game_id, sets = parse(line)
        record[game_id] = sets
      }
      .map { |_game_id, sets|                # for each game (and discarding the game ID)
        sets.reduce { |memo, set|            # find maximum of each color seen in that game
          [:red, :green, :blue].each do |color|
            memo[color] = [memo[color], set[color]].max
          end
          memo
        }
      }
      .map { |color_minimums|                # ..which are the minimum needed to play that game
        color_minimums
          .values                            # ignoring the color names
          .reduce(:*)                        # compute the power for this game's minimum set
      }
      .reduce(:+)                            # and add them up
  end

  # @example
  #   day.parse('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green') #=> [1, [{blue: 3, red: 4}, {red: 1, green: 2, blue: 6}, {green: 2}]]
  def parse(line)
    id, sets = line.split(': ')
    id = id.slice(/\d+$/).to_i

    sets = sets
      .split('; ')
      .map { |set|
        set_hash = Hash.new { |_hash, key| [:blue, :green, :red].include?(key) ? 0 : raise("unknown color '#{key.inspect}'") }

        set
          .split(", ")
          .each { |cubes|
            count, color = cubes.split(" ")
            set_hash[color.to_sym] = count.to_i
          }

        set_hash
      }

    [id, sets]
  end

  # === Again, But Classier ===

  # @example
  #   day.part1_with_class #=> 8
  def part1_with_class
    input
      .split("\n")
      .map { |line| Game.new.parse(line) }
      .reject { |game|                       # reject any game wherein ...
        game.sets.any? { |set|               # any set has too many of a color
          set[:red] > 12 ||
            set[:green] > 13 ||
            set[:blue] > 14
        }
      }
      .map { |game| game.id }
      .reduce(:+)
  end

  # @example
  #   day.part2_with_class #=> 2286
  def part2_with_class
    input
      .split("\n")
      .map { |line| Game.new.parse(line) }
      .map { |game| game.minimum_set }
      .map { |set| set.power}
      .reduce(:+)
  end

  class Game
    attr_reader :id, :sets

    # @example
    #   game = Day02::Game.new
    #   game.parse('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green')
    #   game.id #=> 1
    #   game.sets.first.blue #=> 3
    #   game.sets.last.green #=> 2
    def parse(line)
      id, sets = line.split(': ')
      @id = id.slice(/\d+$/).to_i

      @sets = sets
        .split('; ')
        .map { |set|
          Subset.new.parse(set)
        }

      self
    end

    # @example
    #   game = Day02::Game.new
    #   game.parse('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green')
    #   min_set = game.minimum_set
    #   min_set.blue #=> 6
    #   min_set.green #=> 2
    #   min_set.red #=> 4
    def minimum_set
      sets
        .reduce { |memo, set|
          [:red, :green, :blue].each do |color|
            memo[color] = [memo[color], set[color]].max
          end
          memo
        }
    end
  end

  class Subset
    attr_accessor :blue, :green, :red

    def initialize
      @blue = 0
      @green = 0
      @red = 0
    end

    # @example
    #   subset = Day02::Subset.new
    #   subset.parse('4 red, 2 green, 6 blue')
    #   subset.power #=> 48
    def power
      blue * green * red
    end

    def [](color)
      self.send("#{color}".to_sym)
    end

    def []=(color, count)
      self.send("#{color}=".to_sym, count)
    end

    # @example
    #   subset = Day02::Subset.new
    #   subset.parse('3 blue, 4 red')
    #   subset.blue   #=> 3
    #   subset.red    #=> 4
    #   subset.green  #=> 0
    def parse(input)
      input
        .split(", ")
        .each { |cubes|
          count, color = cubes.split(" ")
          self.send("#{color}=".to_sym, count.to_i)
        }
      self
    end
  end

  EXAMPLE_INPUT = <<~INPUT
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  INPUT
end
