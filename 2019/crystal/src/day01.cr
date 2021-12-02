class Day01
  Day01.go

  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    load_module_masses.map { |mass| ModuleV1.new(mass) }.map(&.fuel_required).reduce(&.+)
  end

  def self.part2
    load_module_masses.map { |mass| ModuleV2.new(mass) }.map(&.fuel_required).reduce(&.+)
  end

  def self.load_module_masses
    File.read("../inputs/day01-input.txt").chomp.split("\n").map(&.to_i)
  end
end

class ModuleV1
  getter mass : Int32

  def initialize(@mass = 0)
  end

  def fuel_required
    (mass / 3).floor - 2
  end
end

class ModuleV2 < ModuleV1
  def fuel_required
    mass_to_fuel(mass)
  end

  private def mass_to_fuel(mass)
    fuel = (mass / 3).floor - 2
    if fuel > 0
      fuel += mass_to_fuel(fuel)
    else
      return 0
    end
  end
end
