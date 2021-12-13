class Day12
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :input

  def initialize(input=nil)
    @input = parse(input || real_input)
  end

  # @example
  #   day.part1 #=> 10
  def part1
    CaveSystem
      .new(input)
      .build_a_rough_map
      .find_paths
      .count
  end

  # @example
  #   day.part2 #=> 36
  def part2
    CaveSystem
      .new(input)
      .build_a_rough_map
      .allow_one_small_revisit
      .find_paths
      .count
  end

  def parse(input)
    input
      .split("\n")
      .map { |line|
        line.split("-")
      }
  end

  def real_input
    File.read('../inputs/day12-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
  INPUT

  SLIGHTLY_LARGER_EXAMPLE_INPUT = <<~INPUT
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
  INPUT

  EVEN_LARGER_EXAMPLE_INPUT = <<~INPUT
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
  INPUT
end

class CaveSystem
  attr_reader :caves

  def initialize(pairs)
    @pairs = pairs
    @caves = {}
    @one_small_revisit = false
  end

  # @example
  #   cs = CaveSystem.new(day.input)
  #   cs.build_a_rough_map
  #   cs.caves['A'].connections #=> ["start", "c", "b", "end"]
  def build_a_rough_map
    @pairs.each do |left, right|
      @caves[left] = @caves[left] || Cave.new(left)
      @caves[right] = @caves[right] || Cave.new(right)
      @caves[left].hook_up(@caves[right].name)
      @caves[right].hook_up(@caves[left].name)
    end

    self
  end

  def allow_one_small_revisit
    @one_small_revisit = true

    self
  end

  # @example
  #   cs = CaveSystem.new(day.input)
  #   cs.build_a_rough_map
  #   cs.find_paths.count #=> 10
  # @example slightly larger
  #   day = Day12.new(Day12::SLIGHTLY_LARGER_EXAMPLE_INPUT)
  #   cs = CaveSystem.new(day.input)
  #   cs.build_a_rough_map
  #   cs.find_paths.count #=> 19
  # @example even larger
  #   day = Day12.new(Day12::EVEN_LARGER_EXAMPLE_INPUT)
  #   cs = CaveSystem.new(day.input)
  #   cs.build_a_rough_map
  #   cs.find_paths.count #=> 226
  def find_paths
    paths_to_the_end = []
    trial_paths = [[caves['start']]]

    while path = trial_paths.pop do
      if path.last.end?
        paths_to_the_end.push(path)
        next
      else
        path
          .last
          .connections
          .map { |next_cave_name|
            @caves[next_cave_name]
          }
          .filter do |next_cave|
            next_cave.can_visit?(path, @one_small_revisit)
          end
          .each { |visitable_cave|
            trial_paths.push(path + [caves[visitable_cave.name]])
          }
      end
    end

    paths_to_the_end
  end
end

class Cave
  attr_reader :name, :connections

  def initialize(name)
    @name = name
    @big = (name.upcase == name)
    @connections = []
  end

  def ==(other)
    self.name == other.name
  end

  # @example
  #   c = Cave.new('fee')
  #   c.connections.length #=> 0
  #   %w[fi fo fum].each do |s|
  #     c.hook_up(Cave.new(s))
  #   end
  #   c.connections.length #=> 3
  #   c.connections.map(&:name) #=> %w[fi fo fum]
  #
  # @example linkages
  #   foo = Cave.new('foo')
  #   bar = Cave.new('bar')
  #   foo.hook_up(bar)
  #   bar.hook_up(foo)
  #   foo.connections.first == bar
  #   bar.connections.first == foo
  def hook_up(other)
    @connections << other
  end

  # @example can visit a small once
  #   start = Cave.new('start')
  #   A = Cave.new('A')
  #   b = Cave.new('b')
  #   c = Cave.new('c')
  #   path = [start, A, b, A]
  #   c.can_visit?(path) #=> true
  # @example can revisit a small once with revisit permission
  #   start = Cave.new('start')
  #   A = Cave.new('A')
  #   b = Cave.new('b')
  #   c = Cave.new('c')
  #   path = [start, A, b, A, c, A]
  #   c.can_visit?(path, true) #=> true
  # @example cannot revisit a small without revisit permission
  #   start = Cave.new('start')
  #   A = Cave.new('A')
  #   b = Cave.new('b')
  #   c = Cave.new('c')
  #   path = [start, A, b, A, c, A]
  #   c.can_visit?(path) #=> false
  # @example cannot revisit a small with revisit permission if another small has been visited
  #   start = Cave.new('start')
  #   A = Cave.new('A')
  #   b = Cave.new('b')
  #   c = Cave.new('c')
  #   path = [start, A, b, A, b, A, c, A]
  #   c.can_visit?(path, true) #=> false
  def can_visit?(visited, one_small_revisit=false)
    case
    when self.start? ; false
    when self.small?
      !visited.include?(self) || # no visits to me yet ... OR ...
        (
          one_small_revisit &&         # revisitation rights granted
          visited                      #          AND
            .filter(&:small?)          # no visited smalls (including me)...
            .tally.values.count(2) < 1 # ... have been visited twice
        )
    else ; true
    end
  end

  # @example big one is big
  #   c = Cave.new('EEK').big? #=> true
  # @example small one is not big
  #   c = Cave.new('nope').big? #=> false
  def big?
    @big
  end

  # @example big one is not small
  #   c = Cave.new('EEK').small? #=> false
  # @example small one is small
  #   c = Cave.new('nope').small? #=> true
  # @example start and end are not considered small
  #   c = Cave.new('start').small? #=> false
  #   c = Cave.new('end').small? #=> false
  def small?
    !@big && !(start? or end?)
  end

  # @example start knows it is the start
  #   c = Cave.new('start').start? #=> true
  # @example knows it is not the start
  #   c = Cave.new('nope').start? #=> false
  def start?
    @name == 'start'
  end

  # @example end knows it is the end
  #   c = Cave.new('end').end? #=> true
  # @example knows it is not the end
  #   c = Cave.new('nope').end? #=> false
  def end?
    @name == 'end'
  end

  def to_s
    # case
    # when start?
    #   "\e[32m#{name}\e[0m"
    # when end?
    #   "\e[31m#{name}\e[0m"
    # else
      name
    # end
  end
end

require 'minitest'

class TestCaveSystem < Minitest::Test
  def test_part2_example
    day = Day12.new(Day12::EXAMPLE_INPUT)
    cs = CaveSystem.new(day.input)
    cs.build_a_rough_map
    cs.allow_one_small_revisit
    paths = cs.find_paths
    assert_equal 36, paths.count
  end

  def test_part2_slightly_larger
    day = Day12.new(Day12::SLIGHTLY_LARGER_EXAMPLE_INPUT)
    cs = CaveSystem.new(day.input)
    cs.build_a_rough_map
    cs.allow_one_small_revisit
    paths = cs.find_paths
    assert_equal 103, paths.count
  end

  def test_part2_even_larger
    day = Day12.new(Day12::EVEN_LARGER_EXAMPLE_INPUT)
    cs = CaveSystem.new(day.input)
    cs.build_a_rough_map
    cs.allow_one_small_revisit
    paths = cs.find_paths
    assert_equal 3509, paths.count
  end
end
