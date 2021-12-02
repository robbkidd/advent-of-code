require "./spec_helper"
require "../src/day01"

describe ModuleV1 do
  it "example one" do
    subject = ModuleV1.new(mass: 12)
    subject.fuel_required.should eq(2)
  end

  it "example two" do
    subject = ModuleV1.new(mass: 14)
    subject.fuel_required.should eq(2)
  end

  it "example three" do
    subject = ModuleV1.new(mass: 1969)
    subject.fuel_required.should eq(654)
  end

  it "example four" do
    subject = ModuleV1.new(mass: 100756)
    subject.fuel_required.should eq(33583)
  end
end

describe ModuleV2 do
  it "example one" do
    subject = ModuleV2.new(mass: 12)
    subject.fuel_required.should eq(2)
  end

  it "example two" do
    subject = ModuleV2.new(mass: 14)
    subject.fuel_required.should eq(2)
  end

  it "example three" do
    subject = ModuleV2.new(mass: 1969)
    subject.fuel_required.should eq(966)
  end

  it "example four" do
    subject = ModuleV2.new(mass: 100756)
    subject.fuel_required.should eq(50346)
  end
end
