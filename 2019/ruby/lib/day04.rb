class Day04
  def self.go
    puts "Part1: #{part1}"
    puts "Part2: #{part2}"
  end

  def self.part1
    validate_input_with(:valid?).length
  end

  def self.part2
    validate_input_with(:really_valid?).length
  end

  def self.validate_input_with(validator)
    input_range.each_with_object([]) do |input, valid_passwords|
      valid_passwords << input if Password.new(input.to_s).send(validator)
    end
  end

  def self.input_range
    @input_range ||= Range.new(
      *File.read('../inputs/day04-input.txt')
           .chomp
           .split("-")
           .map(&:to_i)
    )
  end
end

class Password
  def initialize(password)
    @password = password
  end

  def valid?
    return false unless correct_length?
    [ digits_adjacent?,
      ever_increasing?,
    ].all?
  end

  def really_valid?
    # don't bother further evaluation of the password if it's the wrong length
    return false unless correct_length?

    # this chunk_while takes care of finding adjacent digits
    # > "122444".chars.chunk_while do |current_digit, next_digit|
    # *   current_digit == next_digit
    # * end.to_a
    # => [["1"], ["2", "2"], ["444"]]
    @password.chars.chunk_while do |current_digit, next_digit|

      # early return false from the entire method if numbers decrease
      return false if current_digit > next_digit

      # the boolean criteria by which elements are "chunked"
      # put 'em all together if adjacent digits match
      current_digit == next_digit

    # it's a special kind of awful to chain methods on a do/end block
    # but this is the part that checks that any of the collections of
    # adjacent digits are only a pair
    end.to_a.any? { |chunk| chunk.length == 2 }
  end

  def correct_length?
    @password.length == 6
  end

  def digits_adjacent?
    @password.chars.each_cons(2).map do |first, second|
      first == second
    end.any?
  end

  def ever_increasing?
    @password.chars.each_cons(2).map do |first, second|
      first <= second
    end.all?
  end
end
