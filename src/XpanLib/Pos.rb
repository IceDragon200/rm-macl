#-// 04/19/2012
#-// 04/19/2012
#-inject gen_class_header 'Pos'
#-inject gen_scr_imported_ww 'Pos', '0x10001'
class Pos
  attr_accessor :x,:y
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
  def to_s
    "<#{self.class.name} x#{@x} y#{@y} z#{@z}>"
  end
  def to_hash
    {x: @x,y: @y,z: @z}
  end
  def hash
    [@x,@y,@z].hash
  end
end