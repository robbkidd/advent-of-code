require 'rspec'
require_relative '../lib/day16'

describe TicketRule do
  let(:input) { "class: 1-3 or 5-7" }
  let(:rule) { TicketRule.from_input(input) }

  it "creates a rule from a line of input" do
    expect(rule.to_s).to eq(input)
  end

  it "validates a value" do
    expect(rule.valid_value?(3)).to be true 
    expect(rule.valid_value?(6)).to be true 
    expect(rule.valid_value?(4)).to be false 
    expect(rule.valid_value?(10)).to be false 
  end
end

describe TicketValidator do
  let(:validator) { TicketValidator.new(Day16.example_input) }
  it "knows the rules" do
    rules_input = Day16.example_input.split("\n\n").first.split("\n")
    expect(validator.rules.map(&:to_s)).to eq(rules_input)
  end

  it "knows the nearby tickets" do
    expect(validator.nearby_tickets.first).to eq([7,3,47])
  end

  it "returns the invalid values on a ticket" do
    expect(validator.values_not_valid_for_any_field([7,3,47])).to eq([])
    expect(validator.values_not_valid_for_any_field([40,4,50])).to eq([4])
    expect(validator.values_not_valid_for_any_field([55,2,20])).to eq([55])
    expect(validator.values_not_valid_for_any_field([38,6,12])).to eq([12])
  end

  it "computes the scanning error rate" do
    expect(validator.ticket_scanning_error_rate).to eq(71)
  end
end