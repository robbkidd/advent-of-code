require 'rspec'
require_relative '../lib/day18'

describe "part 1" do
  context "finding inner simple expressions" do
    subject do |example|
      TheNewMath.pluck_simple_expressions(example.description)
    end

    it "1 + 2 * 3 + 4 * 5 + 6" do |example|
      expect(subject).to eq([])
    end
    it "2 * 3 + (4 * 5)" do |example|
      expect(subject).to eq(["☾4 * 5☽"])
    end
    it "5 + (8 * 3 + 9 + 3 * 4 * 3)" do |example|
      expect(subject).to eq(["☾8 * 3 + 9 + 3 * 4 * 3☽"])
    end
    it "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" do |example|
      expect(subject).to eq(["☾8 + 6 * 4☽"])
    end
    it "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" do |example|
      expect(subject).to eq(["☾2 + 4 * 9☽", "☾6 + 9 * 8 + 6☽"])
    end
  end

  context "examples" do
    subject do |example|
      TheNewMath.solve(example.description)
    end

    it "1 + 2 * 3 + 4 * 5 + 6" do |example|
      expect(subject).to eq(71)
    end
    it "2 * 3 + (4 * 5)" do |example|
      expect(subject).to eq(26)
    end
    it "5 + (8 * 3 + 9 + 3 * 4 * 3)" do |example|
      expect(subject).to eq(437)
    end
    it "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" do |example|
      expect(subject).to eq(12240)
    end
    it "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" do |example|
      expect(subject).to eq(13632)
    end
  end
end

describe "part 2" do
  context "add first, then multiply" do
    subject do |example|
      TheNewNewMath.solve(example.description)
    end

    it "1 + 2 * 3 + 4 * 5 + 6" do
      expect(subject).to eq(231)
    end
    it "1 + (2 * 3) + (4 * (5 + 6))" do
      expect(subject).to eq(51)
    end
    it "2 * 3 + (4 * 5)" do
      expect(subject).to eq(46)
    end
    it "5 + (8 * 3 + 9 + 3 * 4 * 3)" do
      expect(subject).to eq(1445)
    end
    it "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" do
      expect(subject).to eq(669060)
    end
    it "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" do
      expect(subject).to eq(23340)
    end
  end
end
