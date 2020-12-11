class Day11
  attr_reader :input

  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    seats = Seats.new
    until seats.stable do
      seats.tick
    end
    seats.occupied_seat_count
  end

  def part2
  end

  def self.example_input
    <<~EXAMPLE
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
    EXAMPLE
  end
end

class Seats
  attr_accessor :state, :stable

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day11-input.txt"))
    @state = start_state
    @states = [] << @state
    @stable = false
  end

  def to_s
    @state.map{|row| row.join }.join("\n")
  end

  def occupied_seat_count
    @state.to_s.count("#")
  end

  def start_state
    @input.split("\n").map{ |row| row.chars }
  end

  def tick
    new_state = next_state
    if @state != new_state
      @state = new_state
      @states << @state
    else
      @stable = true
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
    }.reject{ |seat| seat.nil? }
  end

  def next_state
    (0..height-1).map do |y|
      (0..width-1).map do |x|
        neighbors = neighbors_for(y: y, x: x)
        case state[y][x]
        when "."
          "."
        when "L"
          neighbors.count("#") == 0 ? "#" : "L"
        when "#"
          neighbors.count("#") >= 4  ? "L" : "#"
        else
          raise "Something wrong with your scanner."
        end
      end
    end
  end
end