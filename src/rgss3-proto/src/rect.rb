class Rect

  attr_accessor :x, :y, :width, :height

  def initialize(x=nil, y=nil, w=nil, h=nil)
    set x,y,w,h
  end

  def set(x=nil, y=nil, w=nil, h=nil)
    if x.is_a?(Array)
      x,y,w,h = *x 
    elsif x.is_a?(Rect) 
      x,y,w,h = x.to_a
    end  
    @x, @y, @width, @height = x||0, y||0, w||0, h||0
  end

  def empty
    self.x = self.y = self.width = self.height = 0
  end

  def empty?
    self.width == 0 or self.height == 0
  end

  def to_s
    "<#{self.class.name} x: #{x} y: #{y} width: #{width} height: #{height}>"
  end

end
