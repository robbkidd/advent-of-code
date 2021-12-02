class Day12
  def self.go
    puts "Part1: #{part1}"
    puts "\nPart2: #{part2}"
  end

  def self.part1
    moons = jupiters_moons
    Moon.step_time(moons, 1000)
    moons.map(&:total_energy).reduce(&:+)
  end

  def self.part2
    original_moons = Moon.parse_input(EXAMPLE2)
    moons = original_moons.map(&:dup)
    Moon.step_time(moons)
    steps = 2
    while moons != original_moons do
      Moon.step_time(moons)
      steps += 1
      puts steps if steps % 100_000 == 0
    end
    steps
  end

  def self.jupiters_moons
    input = File.read('../inputs/day12-input.txt').chomp
    Moon.parse_input(input)
  end

  EXAMPLE1 = <<~EXAMPLE1
             <x=-1, y=0, z=2>
             <x=2, y=-10, z=-7>
             <x=4, y=-8, z=8>
             <x=3, y=5, z=-1>
             EXAMPLE1

  EXAMPLE2 = <<~EXAMPLE2
             <x=-8, y=-10, z=0>
             <x=5, y=5, z=10>
             <x=2, y=-7, z=3>
             <x=9, y=-8, z=-3>
             EXAMPLE2

end

class Moon
  require 'securerandom'
  require 'matrix'

  attr_reader :id, :position, :velocity

  def self.parse_input(input)
    input.each_line
         .with_index
         .map { |line, index| parse_line(index, line) }
  end

  def self.parse_line(id, line)
    coords = line.tr('<>','')
                 .split(', ')
                 .map {|pair| pair.split('=')}
                 .map {|axis, value| [axis.to_sym, value.to_i] }
                 .to_h
    new(id: id, x: coords[:x], y: coords[:y], z: coords[:z])
  end

  def self.step_time(moons, step=1)
    step.times do
      moons.each do |moon|
        moon.apply_gravity(moons)
      end
      moons.each do |moon|
        moon.apply_velocity
      end
    end
    moons
  end

  def initialize(id:, x: 0, y: 0, z: 0)
    @id = id || SecureRandom.alphanumeric(5)
    @position = [x, y, z]
    @velocity = [0, 0, 0]
  end

  def apply_gravity(moons)
    moons.reject { |moon| self.id == moon.id }
         .map { |moon| moon.position }
         .transpose
         .each_with_index do |axis_values, index|
            velocity_change = axis_values.map { |value| value <=> position[index]}
                                         .reduce(&:+)
            velocity[index] += velocity_change
          end
  end

  def apply_velocity
    @position = (Matrix[position] + Matrix[velocity]).to_a.first
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  def potential_energy
    position.map(&:abs)
            .reduce(&:+)
  end

  def kinetic_energy
    velocity.map(&:abs)
            .reduce(&:+)
  end

  def ==(other)
    self.id == other.id &&
      self.position == other.position &&
      self.velocity == other.velocity
  end

  def to_s
    [ "pos=<",
      "x=#{position[0].to_s.rjust(5)}, ",
      "y=#{position[1].to_s.rjust(5)}, ",
      "z=#{position[2].to_s.rjust(5)}>, ",
      "vel=<",
      "x=#{velocity[0].to_s.rjust(5)}, ",
      "y=#{velocity[1].to_s.rjust(5)}, ",
      "z=#{velocity[2].to_s.rjust(5)}>"
    ].join
  end
end
