#
# RGSS3-MACL/lib/xpan-lib/geometry/oval.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 1.0.1
require File.join(File.dirname(__FILE__), '..', 'surface')

module MACL
module Geometry

class Oval

  include MACL::Mixin::Surface

  attr_accessor :cx, :cy
  attr_accessor :radius_x, :radius_y
  attr_accessor :angle_offset

  def initialize(x=0, y=0, radius_x=0, radius_y=0)
    @cx, @cy, @radius_x, @radius_y = x, y, radius_x, radius_y
    @angle_offset = 0
  end

  def x
    cx - radius_x
  end

  def y
    cy - radius_y
  end

  def x=(n)
    self.cx = n + radius_x
  end

  def y=(n)
    self.cy = n + radius_y
  end

  def width
    @radius_x * 2
  end

  def height
    @radius_y * 2
  end

  def width=(n)
    @radius_x = n / 2
  end

  def height=(n)
    @radius_y = n / 2
  end

  def diameter_x
    @radius_x * 2
  end

  def diameter_y
    @radius_y * 2
  end

  def calc_xy_from_angle(angle)
    opangle = Math::PI * (angle - @angle_offset) / 180.0
    return @cx + @radius_x * Math.cos(opangle), @cy + @radius_y * Math.sin(opangle)
  end

  def calc_angle x2, y2
    dx, dy = x2 - @cx, y2 - @cy
    m = dx.abs.max(dy.abs).max(1).to_f
    180 + (Math.atan2((dy)/m, (dx)/m) / Math::PI) * -180 rescue 0
  end

  def calc_circ_dist x2, y2
    dx, dy = @cx - x2, @cy - y2
    m = dx.abs.max(dy.abs).max(1).to_f
    (dx * Math.cos(Math::PI * dx / m)).abs + (dy * Math.cos(Math::PI * dy / m)).abs
  end

  def in_circ_area? x, y
    calc_circ_dist(x,y).abs <= calc_circ_dist(*get_angle_xy(calc_angle(x,y))).abs
  end

  def set *args
    if args[0].is_a?(Oval)
      o = args[0]
      self.x, self.y, self.radius_x, self.radius_y = o.x, o.y, o.rdx, o.rdy
    else
      self.x, self.y = args[0] || self.x, args[1] || self.y
      self.radius_x, self.radius_y = args[2] || self.rdx, args[3] || self.rdy
    end
    self
  end

  def empty
    set 0, 0, 0, 0
  end

  def cyc_360_angle(n=0,clockwise=true)
    clockwise ? n.next.modulo(360) : n.pred.modulo(360)
  end

  def cycle_360(n=nil,clockwise=true)
    i = 0
    if n
      n.times { |c| yield i, c ; i = cyc_360_angle(i,clockwise) }
    else
      loop do
        yield i ; i = cyc_360_angle(i,clockwise)
      end
    end
  end

  def circumfrence
    2 * Math::PI * ((radius_x + radius_y) / 2)
  end

end

end
end
