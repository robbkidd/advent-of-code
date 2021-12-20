class Day20
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input_image, :image_enhancement_algorithm

  def initialize(input=nil)
    @input = input || real_input
    @input_image = Hash.new(DARK_PIXEL)
    parse_input
  end

  def part1
  end

  def part2
  end

  LIGHT_PIXEL = "#".freeze
  DARK_PIXEL = ".".freeze

  # @example
  #   day.display_image(day.input_image) #=> Day20::EXAMPLE_INPUT.split("\n\n")[1]
  def display_image(image)
    row_bounds,
    column_bounds = image
      .keys
      .transpose
      .map{ |dimension| Range.new(*dimension.minmax) }

    row_bounds.map { |r|
      column_bounds.map { |c|
        image[[c,r]]
      }.join
    }.join("\n")
    .concat("\n")
  end

  # @example
  #   day.parse_input
  #   day.image_enhancement_algorithm.join #=> Day20::EXAMPLE_INPUT.split("\n\n")[0]
  #   day.input_image #=> {[0, 0]=>"#", [3, 0]=>"#", [0, 1]=>"#", [0, 2]=>"#", [1, 2]=>"#", [4, 2]=>"#", [2, 3]=>"#", [2, 4]=>"#", [3, 4]=>"#", [4, 4]=>"#"}
  def parse_input
    algorithm, image = @input.split("\n\n")

    @image_enhancement_algorithm = algorithm.chomp.chars

    image
      .split("\n")
      .map{|row| row.chars}
      .each_with_index{ |row, r|
        row.each_with_index{ |pixel, c|
          @input_image[[c,r]] = pixel if LIGHT_PIXEL == pixel
        }
      }
  end

  def real_input
    File.read('../inputs/day20-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
  INPUT
end
