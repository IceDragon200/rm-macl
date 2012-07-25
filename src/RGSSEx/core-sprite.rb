#-apndmacro _imported_
#-inject gen_scr_imported 'Core-Sprite', '0x10001'
#-end:
#-inject gen_class_header 'Sprite'
#-skip:
module MACL
  module Mixin
    module Surface
    end
  end
end
#-end:
class Sprite
  include MACL::Mixin::Surface
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