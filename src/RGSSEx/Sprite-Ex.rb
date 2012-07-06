#-inject gen_class_header 'Sprite'
class Sprite
  def move x,y
    self.x,self.y=x,y
  end
  def to_rect
    Rect.new x,y,width,height
  end
  def to_cube
    Cube.new x,y,z,width,height,0
  end
end