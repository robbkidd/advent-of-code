class Day07
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
    @dirs = parse_input(@input)
  end

  # @example
  #   day.part1 #=> 95_437
  def part1
    @dirs
      .map { |dir_name, _| total_dir_size(dir_name) }
      .select{ |dir_size| dir_size < 100_000 }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 24_933_642
  def part2
    disk_size = 70_000_000
    current_free_space = disk_size - total_dir_size("root")
    
    space_needed_for_update = 30_000_000
    delete_at_least_this_much = space_needed_for_update - current_free_space

    @dirs
      .map { |dir_name, _| total_dir_size(dir_name) }
      .select{ |dir_size| dir_size > delete_at_least_this_much }
      .sort
      .first
  end

  # @example e
  #   day.total_dir_size('root/a/e') #=> 584
  # @example a
  #   day.total_dir_size('root/a') #=> 94853
  # @example d
  #   day.total_dir_size('root/d') #=> 24933642
  # @example root
  #   day.total_dir_size('root') #=> 48381165
  def total_dir_size(dir_name)
    @dirs
      .select{ |subdir, _| subdir.start_with?(dir_name) }
      .map{ |_name, size| size }
      .reduce(&:+) 
  end

  # @example
  #   day.parse_input(Day07::EXAMPLE_INPUT) #=> {"root"=>23352670, "root/a"=>94269, "root/a/e"=>584, "root/d"=>24933642}
  def parse_input(input)
    cwd = "root"

    input
      .split("$ ")
      .each_with_object({}) { |command_and_output, dirs| # dirs is updated by and returned from this loop
        command, output = command_and_output.split("\n", 2)

        case command
        when ""         ; :do_nothing
        when "cd /"     ; cwd = "root"
        when "cd .."    ; cwd = cwd.split("/")[0..-2].join("/")
        when /cd (\w*)/ ; cwd += "/#{$1}"

        when "ls"
          dirs[cwd] ||= output
                          .split("\n")
                          .reject { |line| line.start_with?("dir") }
                          .map { |line| line.split(" ") }
                          .reduce(0) { |dir_size, (size, _filename)|
                            dir_size += size.to_i
                          }
        end
      }
  end

  def real_input
    File.read('../inputs/day07-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
  INPUT
end
