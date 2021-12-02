require 'rspec'
require_relative '../lib/day10'

describe "Day 10" do
  let(:example4) {
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
  }

  context "part 1" do
    it "example 1" do
      grid = <<~EXAMPLE1
            ......#.#.
            #..#.#....
            ..#######.
            .#.#.###..
            .#..#.....
            ..#....#.#
            #..#....#.
            .##.#..###
            ##...#..#.
            .#....####
            EXAMPLE1

      day = Day10.new(grid)
      expect(day.most_asteriods_visible_at).to eq(["5, 8", 33])
    end

    it "example 2" do
      grid = <<~EXAMPLE2
            #.#...#.#.
            .###....#.
            .#....#...
            ##.#.#.#.#
            ....#.#.#.
            .##..###.#
            ..#...##..
            ..##....##
            ......#...
            .####.###.
            EXAMPLE2
      day = Day10.new(grid)
      expect(day.most_asteriods_visible_at).to eq(["1, 2", 35])
    end

    it "example 3" do
      grid = <<~EXAMPLE3
            .#..#..###
            ####.###.#
            ....###.#.
            ..###.##.#
            ##.##.#.#.
            ....###..#
            ..#.#..#.#
            #..#.#.###
            .##...##.#
            .....#.#..
            EXAMPLE3
      day = Day10.new(grid)
      expect(day.most_asteriods_visible_at).to eq(["6, 3", 41])
    end

    it "example 4" do
      day = Day10.new(example4)
      expect(day.most_asteriods_visible_at).to eq(["11, 13", 210])
    end
  end

  context "part 2" do
    let(:laser_sweep) {
      Day10.new(example4)
           .laser_sweep_from(Day10::Coord.new(11,13))
    }

    it "shoots some asteroids" do
      expect(laser_sweep[0].to_i).to eq(1112)
      expect(laser_sweep[1].to_i).to eq(1201)
    end
  end
end
