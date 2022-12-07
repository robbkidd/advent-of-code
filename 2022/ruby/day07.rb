class Day07
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
    @dirs = parse_input
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
    space_needed_for_update = 30_000_000
    current_free_space = disk_size - total_dir_size("root")
    
    delete_at_least_this_big = space_needed_for_update - current_free_space

    @dirs
      .map { |dir_name, _| total_dir_size(dir_name) }
      .select{ |dir_size| dir_size > delete_at_least_this_big }
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
      .map{|dir, files| files.empty? ? 0 : files.map{|name,size| size}.reduce(&:+)}
      .reduce(&:+) 
  end

  def parse_input
    cwd = "root"
    @input
      .split("$ ")
      .each_with_object({}) { |cmd_and_output, dirs|
        lines = cmd_and_output.split("\n")
        cmd = lines.shift
        case cmd 
        when "cd /"
          cwd = "root"
        when "cd .."
          cwd = cwd.split("/")[0..-2].join("/")
        when /cd (\w*)/
          cwd += "/#{$1}"
        when "ls"
          dirs[cwd] ||= { }
          lines
            .reject { |line| line.start_with?("dir")}
            .map { |line| line.split(" ") }
            .each { |size, filename| dirs[cwd][filename] = size.to_i }
        else
          :do_nothing
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
