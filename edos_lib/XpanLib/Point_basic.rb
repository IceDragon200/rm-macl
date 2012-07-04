# ╒╕ ♥                                                                Point ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Point is already imported' if ($imported||={})['Point']
($imported||={})['Point']=0x10001
class Point
  def self.to_point array
    Point.new *array[0,1]
  end
  attr_accessor :x, :y
  class << self ; alias :[] :new ; end
  def initialize x=0,y=0
    @x,@y = x,y
  end
  def set x=0,y=0
    @x,@y = x,y
    self
  end
  alias old_to_s to_s
  def to_s
    "<#{self.class.name}: %s, %s>" % [self.x,self.y]
  end
  def to_a
    return @x,@y
  end
  def to_hash
    return {x: @x, y: @y}
  end
  def hash
    [@x,@y].hash
  end
  def unaries
    [@x <=> 0, @y <=> 0]
  end
end