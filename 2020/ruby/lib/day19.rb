class Day19
  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}"
    puts "Part2: #{day.part2}"
  end

  def part1
  end

  def part2
  end

  def self.example1
    <<~EXAMPLE
      0: 1 2
      1: "a"
      2: 1 3 | 3 1
      3: "b"
    EXAMPLE
  end


  def self.example_input
    <<~EXAMPLE
      0: 4 1 5
      1: 2 3 | 3 2
      2: 4 4 | 5 5
      3: 4 5 | 5 4
      4: "a"
      5: "b"

      ababbb
      bababa
      abbbab
      aaabbb
      aaaabbb
    EXAMPLE
  end

end

class MIBSatelliteMessageValidator
  def initialize(input = nil)
    @rules_input, @messages_received = (input || File.read("../inputs/day19-input.txt")).split("\n\n")
  end

  def rules
    @rules ||= @rules_input.split("\n")
                           .map{ |line| line.split(": ") }
                           .map{ |id, pattern|
                              [ id.to_i,
                                 pattern.tr('"','')
                                        .split(" | ")
                                        .map{|p| p.split(" ")
                                                  .map{|n| n.match?(/\d+/) ? n.to_i : n}
                                            }
                              ]
                            }
                           .to_h
  end

  def messages
    @messages ||= @messages_received.split("\n")
  end

  def message_valid_for_rule?(message, rule)
    message.match?(rule_to_regex(rule))
    #rules
  end

  def solver
    @solver ||= Hash.new do |h,k|
      rule = rules[k].map { |subrule|
        subrule.map { |subsubrule|
          String === subsubrule ? subsubrule : h[subsubrule]
        }.join
      }.then { |res| res.length == 1 ? res.first : "(#{res.join('|')})" }

      h[k] = rule
    end
  end

  def create_solver(rules)
    Hash.new do |h,k|
      rule = rules[k].map { |subrule|
        subrule.map { |subsubrule|
          String === subsubrule ? subsubrule : h[subsubrule]
        }.join
      }.then { |res| res.length == 1 ? res.first : "(#{res.join('|')})" }

      h[k] = rule
    end
  end

  # Part 1
  def part1
    solver = create_solver(rules)
    inital_rule = Regexp.new(?^+solver[0]+?$)

    p messages.split("\n").grep(inital_rule).count
  end
  # Part 2

  def part2
    solver = create_solver(rules)
    solver[8] = "(#{solver[42]})+"
    solver[11] = "(?<r>#{solver[42]}\\g<r>?#{solver[31]})"
    inital_rule = Regexp.new(?^+solver[0]+?$)

    p messages.grep(inital_rule).count
  end

  def rule_to_regex(rule_id)
    rule = rules[rule_id]
    while rule.match?(/\d/) do
      loop_rule = rule.dup
      rule.scan(/\d+/) do |other_id|
        loop_rule.gsub!(other_id, rules[other_id.to_i])
      end
      rule = loop_rule
    end
    Regexp.new(
      rule.split(" | ")
          .map{ |p| p.tr(' ', '') }
          .join("|")
          .prepend("^(")
          .concat(")$")
    )
  end
end
