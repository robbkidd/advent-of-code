require_relative 'day'

class Day19 < Day # >

  # @example
  #   day.part1 #=> 19114
  def part1
    parse

    @parts
      .select { |part|
        current_workflow_label = "in"
        until ["A", "R"].include?(current_workflow_label) do
          result = nil
          @workflows.fetch(current_workflow_label)
            .each do |rule|
              break if result = rule.call(part)
            end
          current_workflow_label = result
        end
        current_workflow_label == "A"
      }
      .map { |part|
        %w{x m a s}
          .map { |category| part[category] }
          .reduce(&:+)
      }
      .reduce(&:+)

  end

  # example
  #   day.part2 #=> 'how are you'
  def part2
  end

  # example
  #   day.parse #=> []
  def parse
    workflow_def, parts_def =
      input
        .split("\n\n")

    @parts =
      parts_def
        .split("\n")
        .map { |line|
          line
            .tr('{}', '')
            .split(",")
            .map { |category| category.split("=") }
            .map { |category, rating| [category, rating.to_i] }
            .to_h
        }

    @workflows =
        workflow_def
          .split("\n")
          .map { |line|
            line
              .chomp('}')
              .split('{')
            }
            .map { |label, rules|
              [
                label,
                rules
                  .split(",")
                  .map {|rule|
                    m = rule.match(/^((?<category>[xmas])?(?<op>[<>])?(?<value>\d+)?:(?<send_to>\w+)|(?<default>\w+))$/)
                    proc { |part|
                      if m[:op]
                        part[m[:category]].send(m[:op].to_sym, m[:value].to_i) ? m[:send_to] : nil
                      else
                        m[:default]
                      end
                    }
                  }
              ]
            }
            .to_h
  end

  EXAMPLE_INPUT = <<~INPUT
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
  INPUT
end
