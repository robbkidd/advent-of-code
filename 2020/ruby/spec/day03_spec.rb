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
  end
end
