#
# RGSS3-MACL/lib/xpan-lib/point.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.2
require File.join(File.dirname(__FILE__), 'vector')

module MACL

  class Point2 < Vector2i
  end

  class Point3 < Vector3i
  end

  Point = Point2

end
