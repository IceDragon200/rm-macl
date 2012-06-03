# // 04/19/2012
# // 04/19/2012
class IEI::Pos
  attr_accessor :x, :y
  def initialize( x, y )
    set( x, y )
  end  
  def set( x, y )
    @x, @y = x, y
    return self
  end
end