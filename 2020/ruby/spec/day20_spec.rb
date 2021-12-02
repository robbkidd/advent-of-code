require 'rspec'
require_relative '../lib/day20'

describe ImageTile do
  let(:sample_input_tile) {
    <<~TILE
      Tile 2311:
      ..##.#..#.
      ##..#.....
      #...##..#.
      ####.#...#
      ##.##.###.
      ##...#.###
      .#.#.#..##
      ..#....#..
      ###...#.#.
      ..###..###
    TILE
  }

  it "knows its id" do
    tile = ImageTile.new(sample_input_tile)
    expect(tile.id).to eq(2311)
  end
end
