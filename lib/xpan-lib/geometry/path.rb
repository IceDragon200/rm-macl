#
# RGSS3-MACL/lib/xpan-lib/geometry/path.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 0.0.1
require File.join(File.dirname(__FILE__), '..', 'point')

module MACL
module Geometry

class Path

  attr_accessor :points

  def initialize(*args)
    @points = args.collect do |a|
      a.is_a?(Enumerable) ? MACL::Point.new(*a[0, 1]) : a
    end
  end

  def lerp(rate=1.0)
    cindex  = ((@points.size - 1) * rate.to_f).floor
    nindex  = (cindex + 1).min(@points.size)
    x1, y1  = @points[cindex].to_a
    x2, y2  = @points[nindex].to_a
    return [x1 + (x2 - x1) * rate, y1 + (y2 - y1) * rate]
  end

end

end
end
