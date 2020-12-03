require 'rspec'
require_relative '../lib/day03'



describe Toboggan do
  let(:example_map) {
    map = <<~EXAMPLE_MAP
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
    EXAMPLE_MAP
    map.split("\n")
  }

  describe "#traverse" do
    it "counts how many trees it hits on a particular slope" do
      sled = Toboggan.new(example_map)
      trees_hit = sled.traverse(3, 1)
      expect(trees_hit).to eq(7)
    end

    it "can handle a rise bigger than 1" do
      sled = Toboggan.new(example_map)
      trees_hit = sled.traverse(1, 2)
      expect(trees_hit).to eq(2)
    end
  end

  describe "Part 2" do
    it "finds trees along a bunch of different slopes" do
      sled = Toboggan.new(example_map)
      expect(sled.try_slopes(Day03.slopes)).to eq([2, 7, 3, 4, 2])
    end
  end
end
