#
# RGSS3-MACL/lib/xpan-lib/geometry/line.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 0.0.1
require File.join(File.dirname(__FILE__), 'path')

module MACL
module Geometry

class Line < Path

  def initialize(p1, p2)
    super(p1, p2)
  end

end

end
end
