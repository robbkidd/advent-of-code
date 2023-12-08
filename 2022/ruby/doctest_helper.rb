require "grid"
require "day"
require WhichDay.klass_name.downcase

def day
  @day ||= WhichDay.klass.new(WhichDay.klass::EXAMPLE_INPUT)
end
