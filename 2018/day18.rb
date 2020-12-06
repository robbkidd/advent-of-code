class Day18
  attr_accessor :state

  def self.go
    puts "Part1: #{part1}"
  end

  def self.part1
    day = new
    10.times { day.tick }
    day.current_resource_value
  end

  def initialize(input = nil)
    @input = input ||= File.read("#{self.class.name.downcase}-input.txt")
    @state = start_state
  end

  def tick
    @state = next_state
  end

  def current_resource_value
    to_s.count("|") * to_s.count("#")
  end

  def to_s
    state.map{ |row| row.join }.join("\n")
  end

  def start_state
    @input.split("\n").map{ |row| row.chars }
  end

  def next_state
    (0..height-1).map do |y|
      (0..width-1).map do |x|
        neighbors = neighbors_for(y: y, x: x)
        case state[y][x]
        when "."
          neighbors.count("|") >= 3 ? "|" : "."
        when "|"
          neighbors.count("#") >= 3 ? "#" : "|"
        when "#"
          (neighbors.count("|") >= 1 && neighbors.count("#") >= 1) ? "#" : "."
        else
          raise "Something wrong with your scanner."
        end
      end
    end
  end

  def height
    @height ||= start_state.length
  end

  def width
    @width ||= start_state.first.length
  end

  def neighbors_for(y:, x:)
    neighbor_refs = [-1, -1, 0, 1, 1].permutation(2).to_a.uniq
    neighbor_coords = neighbor_refs.map{ |yd, xd|
      if ( 0 <= y+yd && y+yd < height ) &&
         ( 0 <= x+xd && x+xd < width )
        state[ y+yd ][ x+xd ]
      else 
        nil
      end
    }.reject{ |acre| acre.nil? }
  end
end

require 'rspec'

describe Day18 do
  let(:example_day) {
    Day18.new(<<~INPUT)
      .#.#...|#.
      .....#|##|
      .|..|...#.
      ..|#.....#
      #.#|||#|#|
      ...#.||...
      .|....|...
      ||...#|.#|
      |.||||..|.
      ...#.|..|.
    INPUT
  }

  it "takes input" do
    expect(example_day.height).to eq 10
    expect(example_day.width).to eq 10
  end

  it "looks up neighbors" do
    expect(example_day.start_state[2][3]).to eq "."
    neighbors = example_day.neighbors_for(y:2, x:3)
    expect(neighbors.length).to eq 8
    expect(neighbors.count("|")).to eq 2
    expect(neighbors.count("#")).to eq 1
  end

  it "neighbors handles start edges" do
    expect(example_day.start_state[0][0]).to eq "."
    neighbors = example_day.neighbors_for(y:0, x:0)
    expect(neighbors.length).to eq 3
    expect(neighbors).to eq ["#", ".", "."]
    expect(neighbors.count("|")).to eq 0
    expect(neighbors.count("#")).to eq 1
  end

  it "neighbors handles end edges" do
    y = example_day.height - 1
    x = example_day.width - 1
    expect(example_day.start_state[y][x]).to eq "."
    neighbors = example_day.neighbors_for(y:y, x:x)
    expect(neighbors.length).to eq 3
    expect(neighbors).to eq ["|", ".", "|"]
    expect(neighbors.count("|")).to eq 2
    expect(neighbors.count("#")).to eq 0
  end

  describe "state changes" do
    let(:example_after_one_minute) {
      <<~ONE_MINUTE.chomp
        .......##.
        ......|###
        .|..|...#.
        ..|#||...#
        ..##||.|#|
        ...#||||..
        ||...|||..
        |||||.||.|
        ||||||||||
        ....||..|.
      ONE_MINUTE
    }

    let(:example_after_ten_minutes) {
      <<~TEN_MINUTE.chomp
        .||##.....
        ||###.....
        ||##......
        |##.....##
        |##.....##
        |##....##|
        ||##.####|
        ||#####|||
        ||||#|||||
        ||||||||||
      TEN_MINUTE
    }

    it "next_state" do
      output = example_day.next_state.map{|row| row.join }.join("\n")
      expect(output).to eq example_after_one_minute
    end

    it "tick" do
      example_day.tick
      expect(example_day.to_s).to eq example_after_one_minute
    end

    it "ten ticks" do
      10.times { example_day.tick }
      expect(example_day.to_s).to eq example_after_ten_minutes
      expect(example_day.current_resource_value).to eq 1147
    end
  end
end