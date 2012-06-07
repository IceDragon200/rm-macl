# ╒╕ ♥                                                                  Pos ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
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