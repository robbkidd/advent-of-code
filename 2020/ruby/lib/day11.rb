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
    seats.find_stability
    seats.occupied_seat_count
  end

  def part2
    seats = VisibleSeats.new
    seats.find_stability
    seats.occupied_seat_count
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
  attr_accessor :state, :stable, :height, :width

  OCCUPIED = "#"
  EMPTY = "L"
  FLOOR = "."
  OUT_OF_BOUNDS = nil

  BOX_OFFSETS = [-1, -1, 0, 1, 1].permutation(2).to_a.uniq.freeze

  def initialize(input = nil)
    @input = (input || File.read("../inputs/day11-input.txt"))
    @state = start_state
    @states = [] << @state
    @stable = false
    @height = start_state.length
    @width = start_state.first.length
  end

  def to_s
    @state.map{|row| row.join }.join("\n")
  end

  def occupied_seat_count
    @state.to_s.count(OCCUPIED)
  end

  def start_state
    @input.split("\n").map{ |row| row.chars }
  end

  def find_stability
    tick until stable
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

  def next_state
    (0..height-1).map do |y|
      (0..width-1).map do |x|
        seat_rules[ state[y][x] ].call(y, x)
      end
    end
  end

  def seat_rules
    @seat_rules ||= { 
      FLOOR => -> (_, _) { FLOOR },
      EMPTY => -> (y, x) { neighbors_for(y: y, x: x).count(OCCUPIED) == 0 ? OCCUPIED : EMPTY },
      OCCUPIED => -> (y, x) { neighbors_for(y: y, x: x).count(OCCUPIED) >= 4  ? EMPTY : OCCUPIED },
      OUT_OF_BOUNDS => -> (_, _) { OUT_OF_BOUNDS },
    }
  end

  def neighbors_for(y:, x:)
    neighbor_coords = BOX_OFFSETS.map{ |dy, dx|
      if ( 0 <= y+dy && y+dy < height ) &&
         ( 0 <= x+dx && x+dx < width )
        state[ y+dy ][ x+dx ]
      else 
        OUT_OF_BOUNDS
      end
    }.reject{ |seat| seat == OUT_OF_BOUNDS }
  end
end

class VisibleSeats < Seats
  def seat_rules
    @seat_rules ||= super.merge({ 
      EMPTY => -> (y, x) { visible_seats_for(y: y, x: x).count(OCCUPIED) == 0 ? OCCUPIED : EMPTY },
      OCCUPIED => -> (y, x) { visible_seats_for(y: y, x: x).count(OCCUPIED) >= 5  ? EMPTY : OCCUPIED },
    })
  end
  
  def visible_seats_for(y:, x:)
    vectors = BOX_OFFSETS.dup
    i = 0
    until vectors.all? {|seat| [OCCUPIED, EMPTY, OUT_OF_BOUNDS].include? seat}
      i += 1
      vectors.map! do |in_this_direction|
        case in_this_direction
        when OUT_OF_BOUNDS; OUT_OF_BOUNDS
        when String; in_this_direction
        when Array
          dy, dx = in_this_direction.map {|n| n*i}
          if ( 0 <= y+dy && y+dy < height ) &&
             ( 0 <= x+dx && x+dx < width )
            if [OCCUPIED, EMPTY].include?(state[ y+dy ][ x+dx ])
              state[ y+dy ][ x+dx ] # it's a chair, occupied or empty
            else
              in_this_direction # not a chair, keep checking
            end
          else 
            OUT_OF_BOUNDS # past the edge of the seating area
          end
        end
      end
    end
    vectors.reject{ |seat| seat == OUT_OF_BOUNDS } # chuck out of bounds
  end
end