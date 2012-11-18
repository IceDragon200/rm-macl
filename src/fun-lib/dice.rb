#-inject gen_class_header 'Die'
class Die

  def self.roll(sides=6)
    rand(sides) + 1
  end

  # // Instance level
  def initialize(sides=6)
    @sides = 6
  end

  attr_reader :sides

  def sides=(n)
    raise(ArgumentError, "Die cannot have negative or 0 number of sides") if n < 1
    @sides = n.to_i
  end

  def roll
    rand(@sides) + 1
  end
  
end
