require 'rspec'
require_relative 'grid'

describe Grid do
  let(:example_input_2022_day_12) {
    <<~EXAMPLE
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    EXAMPLE
  }

  describe 'getting and setting' do
    it '#set' do
      grid = Grid.new(".")
      grid.set([0,0], "😃")
      expect(grid.at([0,0])).to eq("😃")
    end

    describe '#at' do
      let(:grid) { Grid.new("S..\n.\n..").parse }

      it 'returns a value from a location on the grid' do
        expect(grid.at([0,0])).to eq("S")
      end

      describe 'for locations off the grid' do
        it 'returns :out_of_bounds' do
          expect(grid.at([100,100])).to eq(:out_of_bounds)
        end
      end
    end
  end

  describe 'finding neighbors' do
    let(:grid) { Grid.new(example_input_2022_day_12).parse }

    it 'returns cardinal direction locations when in-bounds' do
      expect(
        grid.neighbors_for([2,5])
      ).to eq(
        { [-1, 0] => [1, 5],
          [ 1, 0] => [3, 5],
          [ 0,-1] => [2, 4],
          [ 0, 1] => [2, 6]
        }
      )
    end

    it 'returns only in-bound neighbors when on edge' do
      expect(
        grid.neighbors_for([0,0])
      ).to eq(
        { [1, 0] => [1, 0],
          [0, 1] => [0, 1]
        }
      )
    end

    it 'raises exception when grid not parsed yet' do
      grid = Grid.new(example_input_2022_day_12)
      expect {
        grid.neighbors_for([0,0])
      }.to raise_error("No data loaded.")
    end
  end

  describe 'supplying a pre-populated hash' do
    let(:grid) { Grid.new(".").parse }

    it 'substitutes reality' do
      expect(grid.at([0,0])).to eq('.')
      expect(grid.at([1,1])).to eq(:out_of_bounds)
      grid.set_grid( { [0,0] => '😅', [1,1] => '😅'} )
      expect(grid.at([0,0])).to eq('😅')
      expect(grid.at([1,1])).to eq('😅')
      expect(grid.at([2,2])).to eq(:out_of_bounds)
    end

    describe 'incoming grid validation' do
      it 'requires a Hash' do
        expect{
          grid.set_grid([])
        }.to raise_error("A grid's gotta be a Hash")
      end
      it 'requires Hash keys be coordinates' do
        expect{
          grid.set_grid({ a: 1, b: 2})
        }.to raise_error("Grid keys gotta be 2-element Arrays")
      end
    end
  end

  describe 'printing the grid' do
    let(:input) { "abcd\nefgh\n" }
    let(:grid) { Grid.new(input).parse }

    it 'stringifies input values by default' do
      expect(grid.to_s).to eq(input)
    end

    it 'transforms with an assigned to_s_proc' do
      grid.to_s_proc = proc {|_coords, value| (value.ord + 1).chr }
      expect(grid.to_s).to eq("bcde\nfghi\n")
      grid.to_s_proc = nil
      expect(grid.to_s).to eq(input)
    end

    it 'transforms with a given block' do
      expect(
        grid.to_s { |_coords, value| (value.ord + 1).chr }
      ).to eq("bcde\nfghi\n")
    end

    it 'block given takes priority over assigned to_s_proc' do
      grid.to_s_proc = proc {|_, _| raise "to_s_proc called" }
      expect{ grid.to_s }.to raise_error("to_s_proc called")
      expect(
        grid.to_s { |_coords, value| (value.ord + 1).chr }
      ).to eq("bcde\nfghi\n")
    end
  end
end
