class Day16
  def self.go
    day = new
    puts name
    puts "Part1: #{day.part1}" 
    puts "Part2: #{day.part2}"
  end

  def part1
    validator = TicketValidator.new
    validator.ticket_scanning_error_rate
  end

  def part2
  end

  def self.example_input
    <<~EXAMPLE
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50
      
      your ticket:
      7,1,14
      
      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
    EXAMPLE
  end
end

class TicketRule 
  attr_reader :name, :valid_ranges

  def self.from_input(rule_input)
    name, *range_inputs = rule_input.gsub(/(:\s|\sor\s)/, ":").split(":")
    ranges = range_inputs.map do |range_input|
      Range.new(*range_input.split("-").map(&:to_i))
    end
    new(name, ranges)
  end

  def initialize(name, valid_ranges)
    @name = name
    @valid_ranges = valid_ranges
  end

  def valid_value?(value)
    valid_ranges.map {|range| range.include? value}.any?
  end

  def to_s
    "#{name}: #{valid_ranges.join(" or ").gsub(/\.\./, "-")}"
  end
end

class TicketValidator
  def initialize(input = nil)
    @rules_input, @my_ticket, @tickets_input = (input || File.read("../inputs/day16-input.txt")).split("\n\n")
  end

  def rules
    @rules ||= @rules_input.split("\n").map { |rule_line| TicketRule.from_input(rule_line) }
  end

  def nearby_tickets
    @nearby_tickets ||= @tickets_input.split("\n")[1..-1]
                                      .map { |line| line.split(",").map(&:to_i) }
  end

  def ticket_scanning_error_rate
    nearby_tickets.map { |t| values_not_valid_for_any_field(t) }.reduce(&:+).reduce(&:+)
  end

  def values_not_valid_for_any_field(ticket)
    ticket.reject{ |field| rules.map { |r| r.valid_value?(field) }.any? }
  end
end

