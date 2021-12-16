class Day15
  def self.go
    day = new
    puts "Part 1: #{day.part1}"
    puts "Part 2: #{day.part2}"
  end

  attr_reader :cave, :row_bounds, :column_bounds

  def initialize(input=nil)
    @cave = RiskMap.new(input || real_input)
  end

  # @example
  #   day.part1 #=> 40
  def part1
    shortest_path = @cave.shortest_path_to_goal
    puts
    puts @cave.to_s(highlight_path: shortest_path)

    shortest_path[0..-2]
      .map{ |position| cave[position] }
      .reduce(&:+)
  end

  # @example
  #   day.part2 #=> 315
  def part2
    embiggened_cave = RiskMap.new(@cave.grid).embiggen
    shortest_path = embiggened_cave.shortest_path_to_goal
    # don't print this bigger map; it's a doozy
    # puts
    # puts embiggened_cave.to_s(highlight_path: shortest_path)

    shortest_path[0..-2]
      .map{ |position| embiggened_cave[position] }
      .reduce(&:+)
  end

  def real_input
    File.read('../inputs/day15-input.txt')
  end

  EXAMPLE_INPUT = <<~INPUT
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
  INPUT

  EMBIGGENED_EXAMPLE = <<~EMBIGGENED
    11637517422274862853338597396444961841755517295286
    13813736722492484783351359589446246169155735727126
    21365113283247622439435873354154698446526571955763
    36949315694715142671582625378269373648937148475914
    74634171118574528222968563933317967414442817852555
    13191281372421239248353234135946434524615754563572
    13599124212461123532357223464346833457545794456865
    31254216394236532741534764385264587549637569865174
    12931385212314249632342535174345364628545647573965
    23119445813422155692453326671356443778246755488935
    22748628533385973964449618417555172952866628316397
    24924847833513595894462461691557357271266846838237
    32476224394358733541546984465265719557637682166874
    47151426715826253782693736489371484759148259586125
    85745282229685639333179674144428178525553928963666
    24212392483532341359464345246157545635726865674683
    24611235323572234643468334575457944568656815567976
    42365327415347643852645875496375698651748671976285
    23142496323425351743453646285456475739656758684176
    34221556924533266713564437782467554889357866599146
    33859739644496184175551729528666283163977739427418
    35135958944624616915573572712668468382377957949348
    43587335415469844652657195576376821668748793277985
    58262537826937364893714847591482595861259361697236
    96856393331796741444281785255539289636664139174777
    35323413594643452461575456357268656746837976785794
    35722346434683345754579445686568155679767926678187
    53476438526458754963756986517486719762859782187396
    34253517434536462854564757396567586841767869795287
    45332667135644377824675548893578665991468977611257
    44961841755517295286662831639777394274188841538529
    46246169155735727126684683823779579493488168151459
    54698446526571955763768216687487932779859814388196
    69373648937148475914825958612593616972361472718347
    17967414442817852555392896366641391747775241285888
    46434524615754563572686567468379767857948187896815
    46833457545794456865681556797679266781878137789298
    64587549637569865174867197628597821873961893298417
    45364628545647573965675868417678697952878971816398
    56443778246755488935786659914689776112579188722368
    55172952866628316397773942741888415385299952649631
    57357271266846838237795794934881681514599279262561
    65719557637682166874879327798598143881961925499217
    71484759148259586125936169723614727183472583829458
    28178525553928963666413917477752412858886352396999
    57545635726865674683797678579481878968159298917926
    57944568656815567976792667818781377892989248891319
    75698651748671976285978218739618932984172914319528
    56475739656758684176786979528789718163989182927419
    67554889357866599146897761125791887223681299833479
  EMBIGGENED
end

class RiskMap

  attr_reader :start, :goal, :grid

  # @example parsing part 1
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   cave.to_s #=> Day15::EXAMPLE_INPUT
  # @example can be dupped
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   other_cave = RiskMap.new(cave.grid)
  #   other_cave.to_s #=> Day15::EXAMPLE_INPUT
  def initialize(input)
    case input
    when String
      @grid = Hash.new { |(r,c)| :out_of_bounds }
      parse_input_string(input)
    when Hash
      @grid = input.dup
    end

    @row_bounds,
    @column_bounds = @grid
      .keys
      .transpose
      .map{ |dimension| Range.new(*dimension.minmax) }

    @tile_row_length = @row_bounds.count
    @tile_column_length = @column_bounds.count

    @start = [0,0]
    @goal = [@row_bounds.max, @column_bounds.max]
  end

  def [](key)
    grid[key]
  end

  # @example expected goal
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   bigger_cave = RiskMap.new(cave.grid).embiggen
  #   bigger_cave[bigger_cave.goal] #=> 9
  # @example grid matches
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   bigger_cave = RiskMap.new(cave.grid).embiggen
  #   bigger_cave.to_s.split("\n").first #=> Day15::EMBIGGENED_EXAMPLE.split("\n").first
  # @example out of bounds works
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   bigger_cave = RiskMap.new(cave.grid).embiggen
  #   bigger_cave[[1000,1000]] #=> :out_of_bounds
  # @example tiling 0,10
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   bigger_cave = RiskMap.new(cave.grid).embiggen
  #   bigger_cave[[0,10]] #=> 2
  # @example tiling 1,2
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   bigger_cave = RiskMap.new(cave.grid).embiggen
  #   bigger_cave[[1,2]] #=> 8
  # @example tiling 11,12
  #   cave = RiskMap.new(Day15::EXAMPLE_INPUT)
  #   bigger_cave = RiskMap.new(cave.grid).embiggen
  #   bigger_cave[[11,12]] #=> 1
  def embiggen
    mult = 5
    # _lengths_ are +1 higher than the end of the _range_
    # so exclude from the new _range_ the end computed from the previous _length_
    @row_bounds = Range.new(0, (@tile_row_length * mult), exclude_end: true)
    @column_bounds = Range.new(0, (@tile_column_length * mult), exclude_end: true)
    @goal = [@row_bounds.max, @column_bounds.max]

    @grid.default_proc = ->(h, (r,c)) {
      if @row_bounds.cover?(r) && @column_bounds.cover?(c)
        ref_pos = [ (r % @tile_row_length), (c % @tile_column_length) ]
        ref_risk = h[ref_pos]

        h[[r,c]] = maybe_mod_nine(ref_risk + r/@tile_row_length + c/@tile_column_length)
      else
        :out_of_bounds
      end
    }

    self
  end

  def maybe_mod_nine(n)
    n > 9 ? n%9 : n
  end

  def shortest_path_to_goal
    backsteps = { start => nil }
    costs = { start => 0 }
    costs.default = Float::INFINITY

    survey_queue = [[0,start]]
    while (_cost, check_pos = survey_queue.pop) do
      break if check_pos == goal

      adjacent_positions(check_pos).map { |neighbor_pos|
        [ neighbor_pos, grid[neighbor_pos] ]
      }
      .filter { |_neighbor_pos, neighbor_risk|
        neighbor_risk != :out_of_bounds
      }
      .each do |neighbor_pos, neighbor_risk|
        neighbor_cost = costs[check_pos] + neighbor_risk
        if neighbor_cost < costs[neighbor_pos]
          costs[neighbor_pos] = neighbor_cost
          backsteps[neighbor_pos] = check_pos

          survey_queue.push([neighbor_cost, neighbor_pos])
          survey_queue
            .sort_by! { |cost, _pos| cost }
            .reverse!
        end
      end
    end

    path = [goal]
    step_backwards = backsteps[goal]
    while step_backwards do
      path.push(step_backwards)
      step_backwards = backsteps[step_backwards]
    end
    path
  end

  def adjacent_positions(position)
    [[-1, 0],[1, 0],[0, -1],[0, 1]]
      .map { |offset|
        position
          .zip(offset)
          .map {|p| p.reduce(&:+)}
      }
  end

  def parse_input_string(str='')
    str
      .split("\n")
      .map{|row| row.chars.map(&:to_i)}
      .each_with_index { |row, r|
        row.each_with_index{ |risk_level, c|
          @grid[[r,c]] = risk_level
        }
      }
  end

  def to_s(highlight_path: [])
    highlight = !highlight_path.empty?
    @row_bounds.map { |r|
      @column_bounds.map { |c|
        if highlight_path.include?([r,c])
          highlight ? "\e[41m\e[1m#{grid[[r,c]]}\e[0m" : grid[[r,c]].to_s
        else
          if highlight
            "\e[32m#{grid[[r,c]]}\e[0m"
              .prepend(((r/@tile_row_length).even? ^ (c/@tile_column_length).even?) ? "\e[1m" : "")
          else
            grid[[r,c]].to_s
          end
        end
      }.join
    }.join("\n")
    .concat("\n")
  end
end
