require 'rspec'
require_relative '../lib/day02'

describe "Examples" do
  let(:password_list) {
    <<~PASSWORDDB
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    PASSWORDDB
  }

  it "Part 1 has 2 valid passwords" do
    expect(
      password_list.split("\n")
                   .map { |p| PasswordEntry.new(p).valid? }
    ).to eq(
      [true, false, true]
    )
  end

  it "Part 2 has 1 valid password" do
    expect(
      password_list.split("\n")
                   .map { |p| PasswordEntry.new(p, OfficialTobogganCorporatePolicy).valid? }
    ).to eq(
      [true, false, false]
    )
  end
end

describe PasswordEntry do
  describe "#valid?" do
    it "returns true for a password that meets the policy" do
      password = PasswordEntry.new("1-3 a: abcde")
      expect(password.valid?).to be true
    end
    
    it "returns false for a password that does not meet the policy" do
      password = PasswordEntry.new("1-3 b: cdefg")
      expect(password.valid?).to be false
    end
  end
end

describe OldJobPolicy do
  describe "#new" do
    it "sets some things" do
      policy = described_class.new("1-3 a")
      expect(policy.min).to eq 1
      expect(policy.max).to eq 3
      expect(policy.char).to eq "a"
    end
  end

  describe "valid_password?" do
    it "checks passwords" do
      expect(described_class.new("1-3 a").valid_password?("abcde")).to be true
      expect(described_class.new("1-3 b").valid_password?("cdefg")).to be false
      expect(described_class.new("2-9 c").valid_password?("ccccccccc")).to be true
    end
  end
end

describe OfficialTobogganCorporatePolicy do
  describe "#new" do
    it "sets some things" do
      policy = described_class.new("1-3 a")
      expect(policy.first_index).to eq 0
      expect(policy.second_index).to eq 2
      expect(policy.char).to eq "a"
    end
  end

  describe "valid_password?" do
    it "checks passwords" do
      expect(described_class.new("1-3 a").valid_password?("abcde")).to be true
      expect(described_class.new("1-3 b").valid_password?("cdefg")).to be false
      expect(described_class.new("2-9 c").valid_password?("ccccccccc")).to be false
    end
  end
end