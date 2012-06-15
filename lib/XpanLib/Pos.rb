# ╒╕ ♥                                                                  Pos ╒╕
# └┴────────────────────────────────────────────────────────────────────────┴┘
warn 'Pos is already imported' if ($imported||={})['Pos']
($imported||={})['Pos']=0x10000
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