#-inject gen_class_header 'Die'
class Die

  def self.roll sides=6
    rand(sides) + 1
  end

  # // Instance level
  def initialize sides=6
    @sides = 6
  end

  attr_reader :sides

  def sides= n
    @sides = n.to_i
  end

  def roll
    rand(@sides) + 1
  end
  
end
