# TODO: Write documentation for `Aoc2020`
require "./day01"
module Aoc2020
  VERSION = "0.1.0"
end

require "option_parser"

day_to_run = 0

option_parser = OptionParser.parse do |parser|
  parser.banner = "Welcome to Advent of Code 2020!"

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-d DAY", "--day=DAY", "Run this day's puzzle." do |day|
    day_to_run = day.to_i8
  end
end

case day_to_run
when 0
  exit
when 1
  Day01.go
end
