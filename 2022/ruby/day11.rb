require_relative 'day'

class Day11 < Day # >

  # @example
  #   day.part1 #=> 10_605
  def part1
    mitm = MonkeyInTheMiddle.new(input)
    20.times { mitm.play_round }
    mitm.monkey_business
  end

  # @example
  #   day.part2 #=> 2_713_310_158
  def part2
    mitm = MonkeyInTheMiddle.new(input, get_relief: false)
    10_000.times { mitm.play_round }
    mitm.monkey_business
  end


  class MonkeyInTheMiddle
    attr_reader :monkey_count, :items, :inspections

    # @example
    #   mitm = new(Day11::EXAMPLE_INPUT)
    #   mitm.monkey_count #=> 4
    #   mitm.items        #=> [[79, 98], [54, 65, 75, 74], [79, 60, 97], [74]]
    #   mitm.inspections  #=> [0, 0, 0, 0]
    def initialize(input, get_relief: true)
      @input = input
      @get_relief = get_relief

      @items = []
      @ops = []
      @tests = []

      @monkey_count = notes.length
      @inspections = Array.new(@monkey_count, 0)

      divisors = []
      notes.each { |note|
        @items.push( note[:items] )

        sign, value = note[:op]
        @ops  .push( ->(old) { [ old , value == "old" ? old : value.to_i ].reduce(&sign.to_sym) } )

        divisors.push(note[:test_divisor])
        @tests.push( ->(item) { ((item % note[:test_divisor]) == 0) ? note[:true_monkey] : note[:false_monkey] } )
      }

      @testLCM = divisors.reduce(&:*)
    end

    # @example
    #   mitm = new(Day11::EXAMPLE_INPUT)
    #   20.times { mitm.play_round }
    #   mitm.monkey_business #=> 10_605
    #
    # @example
    #   mitm = new(Day11::EXAMPLE_INPUT)
    #   20.times { mitm.play_round }
    #   mitm.inspections #=> [101, 95, 7, 105]
    def monkey_business
      inspections.max(2).reduce(&:*)
    end

    # @example 1 round
    #   mitm = new(Day11::EXAMPLE_INPUT)
    #   mitm.play_round
    #   mitm.to_s      #=> Day11::EXAMPLE_ROUND_1
    #
    # @example 2 rounds
    #   mitm = new(Day11::EXAMPLE_INPUT)
    #   2.times { mitm.play_round }
    #   mitm.to_s      #=> Day11::EXAMPLE_ROUND_2
    #
    # @example 20 rounds
    #   mitm = new(Day11::EXAMPLE_INPUT)
    #   20.times { mitm.play_round }
    #   mitm.to_s      #=> Day11::EXAMPLE_ROUND_20
    def play_round
      @monkey_count.times do |monkeys_turn|
        i_worry_about_inspection = @ops[monkeys_turn]
        monkey_tests_my_worry    = @tests[monkeys_turn]

        while item_worry = @items[monkeys_turn].shift do
          @inspections[monkeys_turn] += 1
          new_worry = manage_worry( i_worry_about_inspection.call(item_worry) )
          throw_to_monkey = monkey_tests_my_worry.call(new_worry)
          @items[throw_to_monkey] << new_worry
        end
      end
    end

    def manage_worry(worry)
      if @get_relief
        ( worry / 3 ).floor
      else # manage my worry myself
        worry % @testLCM
      end
    end

    # @example
    #   m = new(Day11::EXAMPLE_INPUT)
    #   m.notes.count     #=> 4
    #   m.notes.map{|m| m[:id]} #=> (0..3).to_a
    #   m.notes.map{|m| m[:true_monkey]} #=> [2, 2, 1, 0]
    #   m.notes.map{|m| m[:false_monkey]} #=> [3, 0, 3, 1]
    def notes
      @notes ||=
        @input
          .split("\n\n")
          .map { |note|
            lines = note.split("\n")
            {
              id:           lines[0].match(/Monkey (\d+):/)[1].to_i,
              items:        lines[1].match(/Starting items: (.*)/)[1]           .split(", ").map(&:to_i),
              op:           lines[2].match(/Operation: new = old (.*)/)[1]      .split(" "),
              test_divisor: lines[3].match(/Test: divisible by (\d+)/)[1]       .to_i,
              true_monkey:  lines[4].match(/If true: throw to monkey (\d+)/)[1] .to_i,
              false_monkey: lines[5].match(/If false: throw to monkey (\d+)/)[1].to_i
            }
          }
    end

    def to_s
      @items
        .each_with_index
        .map {|items,idx|
          "Monkey #{idx}: #{items}".tr("[]","").strip
        }.join("\n") + "\n"
    end
  end

  EXAMPLE_INPUT = <<~INPUT
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
  INPUT

  EXAMPLE_ROUND_1 = <<~ROUND
    Monkey 0: 20, 23, 27, 26
    Monkey 1: 2080, 25, 167, 207, 401, 1046
    Monkey 2:
    Monkey 3:
  ROUND

  EXAMPLE_ROUND_2 = <<~ROUND
    Monkey 0: 695, 10, 71, 135, 350
    Monkey 1: 43, 49, 58, 55, 362
    Monkey 2:
    Monkey 3:
  ROUND

  EXAMPLE_ROUND_20 = <<~ROUND
    Monkey 0: 10, 12, 14, 26, 34
    Monkey 1: 245, 93, 53, 199, 115
    Monkey 2:
    Monkey 3:
    ROUND
end