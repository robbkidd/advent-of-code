require 'rspec'
require_relative '../lib/day07'

describe LuggageProcessing do
  let(:part1_example_input) {
    <<~INPUT
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
    INPUT
  }

  let(:part1_example) { described_class.new(part1_example_input) }

  it "parses a given rule" do
    short_input = "light red bags contain 1 bright white bag, 2 muted yellow bags."
    shorty = described_class.new(short_input)
    expect(shorty.rules).to eq({ 'light red' => {'bright white' => 1, 'muted yellow' => 2} })
  end

  describe "Part 1 example" do
    it "2 bag colors may directly contain shiny gold" do
      expect(part1_example.which_colors_can_directly_contain("shiny gold")).to eq(["bright white", "muted yellow"])
    end

    it "4 bag colors may directly or indirectly contain shiny gold" do
      expect(part1_example.which_colors_can_contain("shiny gold")).to eq(["bright white", "dark orange", "light red", "muted yellow"])
    end

    it "parses the example input" do
      expect(part1_example.rules).to eq({
        "bright white" => {"shiny gold"=>1},
        "dark olive" => {"dotted black"=>4, "faded blue"=>3},
        "dark orange" => {"bright white"=>3, "muted yellow"=>4},
        "dotted black" => {},
        "faded blue" => {},
        "light red" => {"bright white"=>1, "muted yellow"=>2},
        "muted yellow" => {"faded blue"=>9, "shiny gold"=>2},
        "shiny gold" => {"dark olive"=>1, "vibrant plum"=>2},
        "vibrant plum" => {"dotted black"=>6, "faded blue"=>5},
      })
    end
  end

  describe "Part 2" do
    let(:part2_example_input) {
      <<~INPUT
        shiny gold bags contain 2 dark red bags.
        dark red bags contain 2 dark orange bags.
        dark orange bags contain 2 dark yellow bags.
        dark yellow bags contain 2 dark green bags.
        dark green bags contain 2 dark blue bags.
        dark blue bags contain 2 dark violet bags.
        dark violet bags contain no other bags.
      INPUT
    }

    let(:part2_example) { described_class.new(part2_example_input) }

    context "counts how many pieces of luggage a particular color bag must contain" do
      it "for part1's rules" do
        expect(part1_example.how_many_must_this_color_contain("shiny gold")).to eq 32
      end
      it "for part2's rules" do
        expect(part2_example.how_many_must_this_color_contain("shiny gold")).to eq 126
      end
    end
  end
end