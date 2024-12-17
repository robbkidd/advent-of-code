require_relative 'day'

class Day09 < Day # >

  # @example
  #   f = Day09::FileOnDisk.new(0, 5, 2)
  #   f.to_s #=> '00000..'
  FileOnDisk = Struct.new(:id, :size, :free_after) do
    def to_s
      ("#{id}" * size) + ('.' * free_after)
    end
  end

  # @example
  #   files = new('12345').parse
  #   files.map(&:to_s).join #=> '0..111....22222'
  def parse
    input
      .split('')
      .each_slice(2)
      .with_index
      .map { |(size, free_space), idx| FileOnDisk.new(idx, size.to_i, free_space.to_i) }
  end

  # @example
  #   day.part1 #=> 'hey'
  # @example simple
  #   day = new('12345')
  #   day.part1 #=> "022111222......"
  def part1
    files = parse

    fragged = files.pop
    (0..files.length-1).each do |ptr|
      free_here = files[ptr].free_after
      if free_here > 0
        files.insert(
          ptr+1,
          FileOnDisk.new(fragged.id, [fragged.size, free_here].min, [free_here - fragged.size, 0].max).tap(&:to_s)
        )
        files[ptr].free_after = 0
        fragged.size -= free_here
        files.push(fragged) if fragged.size > 0
      end
    end
    files.map(&:to_s).join
  end


  # @example
  #   day.part2 #=> 'how are you'
  def part2
  end

  EXAMPLE_INPUT = File.read("../inputs/day09-example-input.txt")
end
