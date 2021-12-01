class Day01
	def self.go
		day = Day01.new
		puts "Part 1: #{day.part1}"
		puts "Part 2: #{day.part2}"
	end

	def part1
		sonar_sweep = sonar_sweep_report
		num_increases(sonar_sweep)
	end

	def part2
		sonar_sweep = sonar_sweep_report
		sliding_window_increases(sonar_sweep)
	end

	def num_increases(sonar_sweep)
		sonar_sweep
			.each_cons(2)
			.filter { |prv,nxt| prv < nxt }
			.length
	end

	def sliding_window_increases(sonar_sweep)
		num_increases(
			sonar_sweep
				.each_cons(3)
				.map {|window| window.reduce(&:+) }
		)
	end

	def sonar_sweep_report
    File.read('../inputs/day01-input.txt').split("\n").map(&:to_i)
  end
end
