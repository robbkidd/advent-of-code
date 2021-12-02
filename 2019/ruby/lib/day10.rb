class Day10
  attr_reader :asteroids

  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    @day ||= Day10.new(asteroid_chart)
    @day.most_asteriods_visible_at
  end

  def self.part2
    best_spot, _ = part1
    new_monitoring_station = Coord.new(*best_spot.split(", ").map(&:to_i))

    visible_asteroids = @day.asteroids_visible_from(new_monitoring_station)
    most_in_a_direction = visible_asteroids.map { |_, others| others.length }.max

    laser_sweep = visible_asteroids
                    .sort
                    .group_by { |angle, _others| angle > 90 }
                    .map { |_, roid_data| roid_data.reverse }
                    .reduce(&:+)
                    .map{ |_, others| others.values_at(0..most_in_a_direction) }
                    .transpose
                    .flatten
                    .reject { |o| o.nil? }
    laser_sweep[199].to_i
  end

  Coord = Struct.new(:x, :y) do
    def diff(other)
      [self.x - other.x, self.y - other.y]
    end

    def vector(other)
      Math.atan2(other.x - self.x, -(other.y - self.y)) % (2*Math::PI)
    end

    def distance(other)
      self.diff(other)
          .map(&:abs)
          .reduce(&:+)
    end

    def to_i
      x * 100 + y
    end

    def to_s
      "#{x}, #{y}"
    end
  end

  def initialize(chart)
    @height = chart.lines.length
    @width = chart.lines.first.length
    @asteroids = find_asteroids(chart)
  end

  def most_asteriods_visible_at
    asteroids
      .each_with_object({}) { |roid, roid_data|
        roid_data[roid] = asteroids_visible_from(roid)
      }
      .map { |roid, roid_data| [roid.to_s, roid_data.length]}
      .max_by { |_roid, number_of_asteroids_visible| number_of_asteroids_visible }
  end

  def laser_sweep_from(station)
    visible_asteroids = asteroids_visible_from(station)
    most_in_a_direction = visible_asteroids.map { |_, others| others.length }.max

    laser_sweep = visible_asteroids
                    .sort #.group_by { |angle, _others| angle > 90 }
                    .map { |_, roid_data| roid_data.reverse }
                    .reduce(&:+)
                    # .map{ |_, others| others.first }
                    # .map{ |_, others| others.values_at(0..most_in_a_direction) }
                    # .transpose
                    # .flatten
                    # .reject { |o| o.nil? }
  end

  def asteroids_visible_from(asteroid)
    @asteroids.reject { |other| other == asteroid }
              .group_by { |other| asteroid.vector(other) }
              .map { |angle, others| [angle, others.sort_by {|o| asteroid.distance(o) }] }
  end

  def find_asteroids(chart)
    chart.each_line
         .with_index
         .flat_map { |row, y|
           row.each_char
              .with_index
              .filter { |spot, _x| spot == "#" }
              .map { |_spot, x| Coord.new(x, y) }
         }
  end

  def render(asteroids)

  end
  def self.asteroid_chart
    @asteroid_chart ||= File.read('../inputs/day10-input.txt')
                            .chomp
  end

  def self.example4
    <<~EXAMPLE4
    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##
    EXAMPLE4
  end
end
