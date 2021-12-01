class Day01
	def self.go
		day = Day01.new
		puts "Part 1: #{day.part1}"
	end

	def part1
		sonar_sweep = sonar_sweep_report
		num_increases(sonar_sweep)
	end

	def num_increases(sonar_sweep)
		sonar_sweep
			.each_cons(2)
			.filter { |prv,nxt| prv < nxt }
			.length
	end

	def sonar_sweep_report
    File.read('../inputs/day01-input.txt').split("\n").map(&:to_i)
  end
end
