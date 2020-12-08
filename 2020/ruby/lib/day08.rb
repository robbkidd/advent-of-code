class Day08
  attr_reader :input

  def self.go
    day = new
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2.first[:result]}"
  end

  def part1
    console = GameConsole.new(self.input)
    console.run
  rescue GameConsole::InfiniteLoopError => e
    e.message
  end

  def part2
    patch_sites.map do |patch_site|
      console = GameConsole.new(self.input) 
      console.patch_at(patch_site)
      begin
        {
          patch_site: patch_site,
          result: console.run
        }
      rescue GameConsole::InfiniteLoopError => e
        {
          patch_site: patch_site,
          result: :error
        }
      end
    end.select { |output| output[:result] != :error }
  end

  def patch_sites
    self.input
        .split("\n")
        .each_with_index
        .inject([]) do |patch_sites, (line, index)|
          patch_sites << index if line.match? /^(nop|jmp)/
          patch_sites
        end
  end

  def initialize(input = nil)
    @input = input || File.read("../inputs/day08-input.txt")
  end
end

class GameConsole
  require 'set'

  class InfiniteLoopError < RuntimeError; end
  class InstructionNotPatchable < RuntimeError; end

  InStruction = Struct.new(:op, :raw_arg) do
    def arg
      raw_arg.to_i
    end
  end

  def initialize(input)
    @boot_code = parse(input)
    @accumulator = 0
    @pointer = 0
    @pointers_seen = Set.new
  end

  def parse(input)
    input.split("\n")
         .map { |line| line.split(" ") }
         .map { |(op, arg)| InStruction.new(op, arg) }
  end

  def patch_at(index)
    orig_inst = @boot_code[index]
    new_op = case orig_inst.op
             when "nop"; "jmp"
             when "jmp"; "nop"
             else
               raise InstructionNotPatchable.new("Can't patch #{orig_inst} at #{index}")
             end
    @boot_code[index] = InStruction.new(new_op, orig_inst.arg)
  end

  def run
    while @pointer < @boot_code.length do
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
    @accumulator
  end
end