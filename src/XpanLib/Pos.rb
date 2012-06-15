#-// 04/19/2012
#-// 04/19/2012
#-inject gen_class_header 'Pos'
#-inject gen_scr_imported_ww 'Pos', '0x10000'
class Pos
  attr_accessor :x, :y
  def initialize( x, y )
    set( x, y )
  end  
  def set( x, y )
    @x, @y = x, y
    return self
  end
end