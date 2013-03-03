#
# RGSS3-MACL/lib/xpan-lib/geometry/square.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), 'rectangle')

module MACL
module Geometry
class Square < Rectangle

  def initialize(x, y, w)
    super(x, y, w, w)
  end

  def width=(n)
    @width = @height = n
  end

  def height=(n)
    @width = @height = n
  end

end
end
end
