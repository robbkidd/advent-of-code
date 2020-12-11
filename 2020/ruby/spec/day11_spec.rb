require 'rspec'
require_relative '../lib/day11'

describe "Day 11" do


end

describe Seats do
  let(:example_seats) {
    Seats.new(Day11.example_input)
  }

  it "has state" do
    expect(example_seats.state[2][3]).to eq "."
  end

  it "looks up neighbors" do
    expect(example_seats.start_state[2][3]).to eq "."
    neighbors = example_seats.neighbors_for(y:2, x:3)
    expect(neighbors.length).to eq 8
    expect(neighbors.count("L")).to eq 7
    expect(neighbors.count(".")).to eq 1
  end

  it "neighbors handles start edges" do
    expect(example_seats.start_state[0][0]).to eq "L"
    neighbors = example_seats.neighbors_for(y:0, x:0)
    expect(neighbors.length).to eq 3
    expect(neighbors).to eq [".", "L", "L"]
    expect(neighbors.count("L")).to eq 2
    expect(neighbors.count(".")).to eq 1
  end

  it "neighbors handles end edges" do
    y = example_seats.height - 1
    x = example_seats.width - 1
    expect(example_seats.start_state[y][x]).to eq "L"
    neighbors = example_seats.neighbors_for(y:y, x:x)
    expect(neighbors.length).to eq 3
    expect(neighbors).to eq [".", "L", "L"]
    expect(neighbors.count("L")).to eq 2
    expect(neighbors.count(".")).to eq 1
  end

  describe "state changes" do
    let(:after_one_round) {
      <<~SEATS
      #.##.##.##
      #######.##
      #.#.#..#..
      ####.##.##
      #.##.##.##
      #.#####.##
      ..#.#.....
      ##########
      #.######.#
      #.#####.##
      SEATS
    }

    let(:after_two_rounds) {
      <<~SEATS
        #.LL.L#.##
        #LLLLLL.L#
        L.L.L..L..
        #LLL.LL.L#
        #.LL.LL.LL
        #.LLLL#.##
        ..L.L.....
        #LLLLLLLL#
        #.LLLLLL.L
        #.#LLLL.##
      SEATS
    }

    let(:after_five_rounds) {
      <<~SEATS
        #.#L.L#.##
        #LLL#LL.L#
        L.#.L..#..
        #L##.##.L#
        #.#L.LL.LL
        #.#L#L#.##
        ..L.L.....
        #L#L##L#L#
        #.LLLLLL.L
        #.#L#L#.##
      SEATS
    }

    it "looks like the one round example" do
      output = example_seats.next_state.map{|row| row.join }.join("\n")
      expect(output).to eq after_one_round.chomp
    end

    it "looks like the two round example" do
      2.times { example_seats.tick }
      expect(example_seats.to_s).to eq after_two_rounds.chomp
    end

    it "looks like the five round example" do
      5.times { example_seats.tick }
      expect(example_seats.to_s).to eq after_five_rounds.chomp
      expect(example_seats.occupied_seat_count).to eq 37
    end

    it "finds stability" do
      until example_seats.stable do
        puts "tick"
        example_seats.tick
      end
      expect(example_seats.occupied_seat_count).to eq 37
    end
  end
end