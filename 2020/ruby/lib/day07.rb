class Day07
  def self.go
    luggage = LuggageProcessing.new
    puts "Part1: #{ luggage.which_colors_can_contain("shiny gold").count }"
  end
end

class LuggageProcessing
  def initialize(input = nil)
    @input = input || File.read("../inputs/day07-input.txt")
  end

  def which_colors_can_contain(target_color)
    prev_ok_count = 0
    ok_colors = which_colors_can_directly_contain(target_color)

    while ok_colors.length > prev_ok_count
      prev_ok_count = ok_colors.length
      ok_colors.each do |ok_color|
        which_colors_can_directly_contain(ok_color).each do |new_ok_color|
          ok_colors << new_ok_color unless ok_colors.include?(new_ok_color)
        end
      end
    end

    ok_colors.sort
  end

  def which_colors_can_directly_contain(target_color)
    rules.select{ |color, contains| color if contains[target_color] }
         .keys
  end

  def input
    @input.gsub(/ bags?\.?/, '')
          .split("\n")
  end

  def rules
    @rules ||= rules_from_input
  end

  def rules_from_input
    input.map { |rule| rule.split(" contain ") }
         .inject({}) do |rules, (bag_color, rest)|
          rules[bag_color] = rest.split(", ")
                                 .inject({}) do |contains, number_and_color|
                                   if number_and_color == "no other"
                                     {}
                                   else
                                     count, *color = number_and_color.split(" ")
                                     contains[color.join(" ")] = count.to_i
                                     contains
                                   end
                                 end
           rules
         end
  end
end