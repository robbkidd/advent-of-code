require 'rspec'
require_relative '../lib/day02'

DATABASE = <<~PASSWORDDB
             1-3 a: abcde
             1-3 b: cdefg
             2-9 c: ccccccccc
           PASSWORDDB

describe "Example" do
  it "has 2 valid passwords" do
    password_list = <<~PASSWORD_LIST
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    PASSWORD_LIST
    
    expect(
      password_list.split("\n")
                   .map { |p| PasswordEntry.new(p).valid? }
    ).to eq(
      [true, false, true]
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

describe Policy do
  describe "#new" do
    it "sets some things" do
      policy = Policy.new("1-3 a")
      expect(policy.min).to eq 1
      expect(policy.max).to eq 3
      expect(policy.char).to eq "a"
    end
  end
end