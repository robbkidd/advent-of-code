require 'rspec'
require_relative '../lib/day04'

describe Passport do
  let(:example_input) {
    <<~PASSPORTS
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
    PASSPORTS
  }
  let(:scanned_input) { Passport.scanner(example_input.split("\n"))}

  describe "Part 1" do
    it "validates passports but with our hack" do
      expect(scanned_input.map(&:all_required_fields_present?)).to eq [true, false, true, false]
    end
  end

  describe "Part 2" do
    it "example invalid passports" do
      input = <<~INVALID
                eyr:1972 cid:100
                hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

                iyr:2019
                hcl:#602927 eyr:1967 hgt:170cm
                ecl:grn pid:012533040 byr:1946

                hcl:dab227 iyr:2012
                ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

                hgt:59cm ecl:zzz
                eyr:2038 hcl:74454a iyr:2023
                pid:3556412378 byr:2007
              INVALID
      invalid_passports = Passport.scanner(input.split("\n"))
      expect(invalid_passports.map(&:valid?)).to eq [false, false, false, false]
    end

    it "example valid passports" do
      input = <<~VALID
                pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
                hcl:#623a2f
                
                eyr:2029 ecl:blu cid:129 byr:1989
                iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
                
                hcl:#888785
                hgt:164cm byr:2001 iyr:2015 cid:88
                pid:545766238 ecl:hzl
                eyr:2022
                
                iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
              VALID
      valid_passports = Passport.scanner(input.split("\n"))
      expect(valid_passports.map(&:valid?)).to eq [true, true, true, true]
    end

    describe "field validation rules" do
      it "validates birth year" do
        birth_year_rule = Passport::FIELD_RULES["byr"]
        expect(birth_year_rule.call("2002")).to be true
        expect(birth_year_rule.call("2003")).to be false
      end
    
      it "validates height" do
        height_rule = Passport::FIELD_RULES["hgt"]
        expect(height_rule.call("60in")).to be true
        expect(height_rule.call("190cm")).to be true
        expect(height_rule.call("190in")).to be false
        expect(height_rule.call("190")).to be false
      end

      it "validates hair color" do
        hair_color_rule = Passport::FIELD_RULES["hcl"]
        expect(hair_color_rule.call("#123abc")).to be true
        expect(hair_color_rule.call("#123abz")).to be false
        expect(hair_color_rule.call("123abc")).to be false
      end
    
      it "validates eye color" do
        eye_color_rule = Passport::FIELD_RULES["ecl"]
        expect(eye_color_rule.call("brn")).to be true
        expect(eye_color_rule.call("wat")).to be false
      end

      it "validates passport id" do
        passport_id_rule = Passport::FIELD_RULES["pid"]
        expect(passport_id_rule.call("000000001")).to be true
        expect(passport_id_rule.call("0123456789")).to be false
      end
    end
  end
end
