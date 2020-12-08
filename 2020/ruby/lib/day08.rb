class Day08
  attr_reader :input

  def self.go
    day = new
    puts "Part1: #{day.part1}" 
    puts "Part2: "
  end

  def part1
    console = GameConsole.new(self.input)
    console.run
  rescue GameConsole::InfiniteLoopError => e
    e.message
  end

  def initialize(input = nil)
    @input = input || File.read("../inputs/day08-input.txt")
  end
end

class GameConsole
  require 'set'

  class InfiniteLoopError < RuntimeError; end

  InStruction = Struct.new(:op, :raw_arg) do
    def arg
      raw_arg.to_i
    end
  end

  def initialize(input)
    @boot_code = parse(input).freeze
    @accumulator = 0
    @pointer = 0
    @pointers_seen = Set.new
  end

  def parse(input)
    input.split("\n")
         .map { |line| line.split(" ") }
         .map { |(op, arg)| InStruction.new(op, arg) }
  end

  def run
    loop do
      if @pointers_seen.add?(@pointer)
        inst = @boot_code[@pointer]
        case inst.op
        when "nop"
          @pointer += 1
        when "acc"
          @accumulator += inst.arg
          @pointer += 1
        when "jmp"
          @pointer += inst.arg
        end
      else
        raise InfiniteLoopError.new("accumulated #{@accumulator}")
      end
    end
  end
end