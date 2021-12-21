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

    @infinite_odd_default = @image_enhancement_algorithm.at("000000000".to_i(2))
    @infinite_even_default = @image_enhancement_algorithm.at("111111111".to_i(2))
  end

  # @example
  #   day.part1 #=> 35
  def part1
    output_image =
      2.times
        .inject(@input_image.dup) {|img, n|
          puts ugly_christmas_sweater(display_image(img))
          enhance(img, n)
        }
    puts ugly_christmas_sweater(display_image(output_image))
    output_image
      .filter{ |_coord, pixel| pixel == LIGHT_PIXEL }
      .count
  end

  def part2
    output_image =
      50.times
        .inject(@input_image.dup) {|img, n|
          enhance(img, n)
        }
    output_image
      .filter{ |_coord, pixel| pixel == LIGHT_PIXEL }
      .count
  end

  LIGHT_PIXEL = "#".freeze
  DARK_PIXEL = ".".freeze

  def enhance(image, iteration=1)
    x_bounds, y_bounds = image_bounds(image)
    image.default = iteration.even? ? @infinite_even_default : @infinite_odd_default

    enlarged_x_bounds = Range.new(x_bounds.min-1, x_bounds.max+1)
    enhanced_image = Hash.new

    y_bounds.map { |y|
      x_bounds.map { |x|
        enhanced_image[[x,y]] = convert_pixel([x,y], image)
      }
    }

    enhanced_image
  end

  def image_bounds(image)
    image
      .keys
      .transpose
      .map{ |dimension| dimension.minmax }
      .map{ |min, max| Range.new(min-2, max+2) }
  end

  # @example
  #   day.convert_pixel([2,2], day.input_image) #=> "#"
  def convert_pixel(pixel, image)
    @image_enhancement_algorithm.at(
      pixel_grid(pixel)
        .map{|loc| image[loc] }
        .join
        .tr(".#", "01")
        .to_i(2)
    )
  end

  # @example
  #   PIXEL_OFFSETS.include?([0,0]) #=> true
  PIXEL_OFFSETS = [
    [-1,-1], [ 0,-1], [ 1,-1],
    [-1, 0], [ 0, 0], [ 1, 0],
    [-1, 1], [ 0, 1], [ 1, 1]
  ].freeze

  # @example
  #   day.pixel_grid([5,10]) #=> [[4, 9], [5, 9], [6, 9], [4, 10], [5, 10], [6, 10], [4, 11], [5, 11], [6, 11]]
  def pixel_grid(pixel)
    PIXEL_OFFSETS.map{ |offset|
      pixel
        .zip(offset)
        .map { |p| p.reduce(&:+) }
    }
  end

  def display_image(image)
    x_bounds,
    y_bounds = image_bounds(image)

    y_bounds.map { |y|
      x_bounds.map { |x|
        image[[x,y]]
      }.join
    }.join("\n")
    .concat("\n")
  end

  def ugly_christmas_sweater(output)
    output
      .gsub(/#/, "\e[41m\e[1m#\e[0m")
      .gsub(/\./, "\e[32m.\e[0m")
  end



  # @example
  #   day.parse_input
  #   day.image_enhancement_algorithm.join #=> Day20::EXAMPLE_INPUT.split("\n\n")[0]
  #   day.image_enhancement_algorithm.count #=> 512
  def parse_input
    algorithm, image = @input.split("\n\n")

    @image_enhancement_algorithm = algorithm.chomp.chars

    image
      .split("\n")
      .map{|row| row.chars}
      .each_with_index{ |row, y|
        row.each_with_index{ |pixel, x|
          @input_image[[x,y]] = pixel
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

  EXAMPLE_BEFORE_ENHANCEMENT = <<~ORIG
    ...............
    ...............
    ...............
    ...............
    ...............
    .....#..#......
    .....#.........
    .....##..#.....
    .......#.......
    .......###.....
    ...............
    ...............
    ...............
    ...............
    ...............
  ORIG

  EXAMPLE_ONE_ENHANCEMENT = <<~ENHANCE
    ...............
    ...............
    ...............
    ...............
    .....##.##.....
    ....#..#.#.....
    ....##.#..#....
    ....####..#....
    .....#..##.....
    ......##..#....
    .......#.#.....
    ...............
    ...............
    ...............
    ...............
  ENHANCE
end
