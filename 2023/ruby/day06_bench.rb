require_relative 'day06'
require 'benchmark/ips'

day = Day06.new
day.input_part2

Benchmark.ips do |x|
  x.report('part2-map-reduce') { day.part2_map_reduce}
  x.report('part2-split') { day.part2_split }

  x.compare!
end
