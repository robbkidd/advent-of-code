require 'rspec'
require_relative '../lib/day15'

describe MemoryGame do
  context "plays the first example" do
    it "4 rounds" do
      game = MemoryGame.new([0,3,6])
      expect(game.spoken_at_round(4)).to eq(0)
    end

    it "5 rounds" do
      game = MemoryGame.new([0,3,6])
      expect(game.spoken_at_round(5)).to eq(3)
    end

    it "6 rounds" do
      game = MemoryGame.new([0,3,6])
      expect(game.spoken_at_round(6)).to eq(3)
    end

    it "7 rounds" do
      game = MemoryGame.new([0,3,6])
      expect(game.spoken_at_round(7)).to eq(1)
    end

    it "8 rounds" do
      game = MemoryGame.new([0,3,6])
      expect(game.spoken_at_round(8)).to eq(0)
    end
  end

  it "other 2020 examples" do
    game = MemoryGame.new([1,3,2])
    expect(game.spoken_at_round(2020)).to eq(1)
    game = MemoryGame.new([2,1,3])
    expect(game.spoken_at_round(2020)).to eq(10)
    game = MemoryGame.new([1,2,3])
    expect(game.spoken_at_round(2020)).to eq(27)
    game = MemoryGame.new([2,3,1])
    expect(game.spoken_at_round(2020)).to eq(78)
    game = MemoryGame.new([3,2,1])
    expect(game.spoken_at_round(2020)).to eq(438)
    game = MemoryGame.new([3,1,2])
    expect(game.spoken_at_round(2020)).to eq(1836)
  end
end