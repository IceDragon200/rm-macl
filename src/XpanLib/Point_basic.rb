#-inject gen_class_header 'Point'
#-inject gen_scr_imported_ww 'Point', '0x10000'
class Point
  attr_accessor :x, :y
  class << self ; alias :[] :new ; end
  def initialize(x=0,y=0)
    @x, @y = x, y
  end
  def set(x=0,y=0)
    @x, @y = x, y
    self
  end
  alias old_to_s to_s
  def to_s
    "<Point: %s, %s>" % [self.x,self.y]
  end
  def to_a
    return @x,@y
  end
  def to_hsh
    return {x: @x, y: @y}
  end
  def hash
    [@x,@y].hash
  end
end