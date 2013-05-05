#
# RGSS3-MACL/lib/xpan-lib/geometry/rectangle.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 18/04/2013
# vr 1.1.0
require File.join(File.dirname(__FILE__), '..', 'surface')

module MACL
module Geometry
class Rectangle

  include MACL::Mixin::Surface

  attr_accessor :x, :y, :width, :height

  def initialize(*args)
    set(*args)
  end

  def set(*args)
    case args.size
    when 1
      arg, = args
      case arg
      when MACL::Geometry::Rectangle, Rect
        x, y, w, h = arg.x, arg.y, arg.width, arg.height
      when Hash
        x, y, w, h = arg[:x], arg[:y], arg[:width], arg[:height]
      when Array
        x, y, w, h = *arg
      else
        raise(TypeError,
              "expected Rect, Array, Hash or MACL::Geometry::Rectangle but received %s" %
                arg.class.name)
      end
    when 4
      x, y, w, h = *args
    end
    @x, @y, @width, @height = x, y, w, h
  end

  def get_points
    cPoint = MACL::Geometry::Point
    [cPoint.new(x, y), cPoint.new(x2, y), cPoint.new(x, y2), cPoint.new(x2, y2)]
  end

  def to_a
    [x, y, width, height]
  end

  def square?
    return width == height
  end

end
end
end
