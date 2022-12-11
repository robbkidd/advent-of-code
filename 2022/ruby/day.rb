class WhichDay
  def self.number
    ENV
      .fetch("DAY", Time.now.day)
      .to_i
      .to_s
      .rjust(2, '0')
  end

  def self.klass_name
    @klass_name ||= "Day#{number}"
  end
  
  def self.klass
    @klass ||= Kernel.const_get(klass_name)
  end

  def self.input_filename
    @input_filename ||= "../inputs/#{klass_name.downcase}-input.txt"
  end
end

class Day
  attr_reader :input

  def self.go
    new.go
  end

  def go
    puts "Part 1: #{part1}"
    puts "Part 2: #{part2}"
  end

  def initialize(input=nil)
    @input = input || real_input
  end

  def part1
    raise NotImplementedError, "You have to write me."
  end

  def part2
    raise NotImplementedError, "You have to write me."
  end

  def real_input
    input_filename = "../inputs/#{self.class.name.downcase}-input.txt"
    File.read(input_filename)
  end

  # for use with outputs that are periods and octothorps
  def ugly_christmas_sweater(output)
    output
      .gsub(/#/, "\e[41m\e[1m#\e[0m")
      .gsub(/\./, "\e[32m.\e[0m")
  end
end