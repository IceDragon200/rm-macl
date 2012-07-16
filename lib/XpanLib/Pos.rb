# ╒╕ ♥                                                                  Pos ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
class Pos
  attr_accessor :x,:y,:z
  class << self ; alias :[] :new ; end
  def initialize x=0,y=0,z=0
    set x,y,z
  end
  def set x=nil,y=nil,z=nil
    @x,@y,@z=x||@x,y||@y,z||@z
    self
  end
  def to_a
    [@x,@y,@z]
  end
  alias old_to_s to_s
  def to_s
    "<#{self.class.name} x: %s, y: %s, z: %s>" % [@x,@y,@z]
  end
  def to_hash
    {x: @x,y: @y,z: @z}
  end
  def hash
    [@x,@y,@z].hash
  end
  def unaries
    to_a.map! &:unary
  end
end