require 'rspec'
require_relative '../lib/day05'

describe "Part 1 examples" do
  it "BFFFBBFRRR: row 70, column 7, seat ID 567." do
    pass = BoardingPass.new("BFFFBBFRRR")
    expect(pass.seat_id).to eq 567
  end
  it "FFFBBBFRRR: row 14, column 7, seat ID 119." do
    pass = BoardingPass.new("FFFBBBFRRR")
    expect(pass.seat_id).to eq 119
  end
  it "BBFFBBFRLL: row 102, column 4, seat ID 820." do
    pass = BoardingPass.new("BBFFBBFRLL")
    expect(pass.seat_id).to eq 820
  end
end

describe "ಠ_ಠ" do

  def just_translate_it_to_binary(code)
    code.tr("FL", "0").tr("BR", "1").to_i(2)
  end

  it "BFFFBBFRRR: row 70, column 7, seat ID 567." do
    expect(just_translate_it_to_binary("BFFFBBFRRR")).to eq 567
  end

  it "FFFBBBFRRR: row 14, column 7, seat ID 119." do
    expect(just_translate_it_to_binary("FFFBBBFRRR")).to eq 119
  end

  it "BBFFBBFRLL: row 102, column 4, seat ID 820." do
    expect(just_translate_it_to_binary("BBFFBBFRLL")).to eq 820
  end
end