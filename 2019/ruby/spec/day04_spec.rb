
require 'rspec'
require_relative '../lib/day04'

describe Password do
  context "validation" do
    it "part 1 examples" do
      expect(Password.new("111111")).to be_valid
      expect(Password.new("122345")).to be_valid
      expect(Password.new("111123")).to be_valid

      expect(Password.new("223450")).not_to be_valid
      expect(Password.new("123789")).not_to be_valid
    end

    it "part 2 examples" do
      expect(Password.new("112233")).to be_really_valid
      expect(Password.new("122345")).to be_really_valid
      expect(Password.new("122345")).to be_really_valid

      expect(Password.new("111123")).not_to be_really_valid
      expect(Password.new("223450")).not_to be_really_valid
      expect(Password.new("123789")).not_to be_really_valid
      expect(Password.new("123444")).not_to be_really_valid
      expect(Password.new("111111")).not_to be_really_valid
    end

    context "correct length" do
      it "yes" do
        expect(Password.new("111111")).to be_correct_length
      end

      it "no" do
        expect(Password.new("11111")).not_to be_correct_length
      end
    end

    context "adjacent digits" do
      it "yes" do
        expect(Password.new("111111")).to be_digits_adjacent
        expect(Password.new("122345")).to be_digits_adjacent
      end

      it "no" do
        expect(Password.new("123454")).not_to be_digits_adjacent
        expect(Password.new("123789")).not_to be_digits_adjacent
      end
    end

    context "always increasing" do
      it "yes" do
        expect(Password.new("123789")).to be_ever_increasing
      end

      it "no" do
        expect(Password.new("123454")).not_to be_ever_increasing
      end
    end
  end
end
