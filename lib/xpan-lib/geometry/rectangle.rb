#
# RGSS3-MACL/lib/xpan-lib/geometry/rectangle.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), '..', 'surface')

module MACL
module Geometry
class Rectangle

  include MACL::Mixin::Surface

  attr_accessor :x, :y, :width, :height

  def initialize(x=0, y=0, w=0, h=0)
    @x, @y, @width, @height = x, y, w, h
  end

  def get_points
    cPoint = MACL::Geometry::Point
    return [
      cPoint.new(x, y),
      cPoint.new(x2, y),
      cPoint.new(x, y2),
      cPoint.new(x2, y2)
    ]
  end

end
end
end