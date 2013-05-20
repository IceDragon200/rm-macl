#
# RGSS3-MACL/lib/xpan-lib/geometry/oval.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 18/04/2013
# vr 1.1.0
module MACL
module Geometry
class Oval

  include MACL::Mixin::Surface

  attr_accessor :cx, :cy
  attr_accessor :radius_x, :radius_y
  attr_accessor :angle_offset

  ##
  # initialize(Oval oval)
  # initialize(Integer x, Integer y, Integer radius_x, Integer radius_y)
  def initialize(*args)
    set(*args)
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

  def calc_angle(x2, y2)
    dx, dy = x2 - @cx, y2 - @cy
    m = dx.abs.max(dy.abs).max(1).to_f
    180 + (Math.atan2((dy)/m, (dx)/m) / Math::PI) * -180 rescue 0
  end

  def calc_circ_dist(x2, y2)
    dx, dy = @cx - x2, @cy - y2
    m = dx.abs.max(dy.abs).max(1).to_f
    (dx * Math.cos(Math::PI * dx / m)).abs + (dy * Math.cos(Math::PI * dy / m)).abs
  end

  def in_circ_area?(x, y)
    calc_circ_dist(x, y).abs <= calc_circ_dist(*get_angle_xy(calc_angle(x,y))).abs
  end

  ##
  # set(Oval oval)
  # set(Hash hash<Symbol, Integer>)
  #
  def set(*args)
    case args.size
    when 0 then x, y, rx, ry = 0, 0, 0, 0
    when 1
      arg, = args
      case arg
      when MACL::Geometry::Oval
        x, y, rx, ry = arg.x, arg.y, arg.radius_x, arg.radius_y
      when Hash
        x, y, rx, ry = arg[:x], arg[:y], arg[:radius_x], arg[:radius_y]
      when Array
        x, y, rx, ry = *arg
      else
        raise(TypeError,
              "expected Array, Hash or MACL::Geometry::Oval but received %s" %
                arg.class.name)
      end
    when 4
      x, y = args[0] || self.x, args[1] || self.y
      rx, ry = args[2] || self.radius_x, args[3] || self.radius_y
    else
      raise(ArgumentError, "expected 0, 1 or 4 arguments but received %s" %
            args.size)
    end
    self.x, self.y, self.radius_x, self.radius_y = x, y, rx, ry
    self
  end

  ##
  # empty
  def empty
    set(0, 0, 0, 0)
  end

  ##
  # cyc_360_angle(n, clockwise)
  def cyc_360_angle(n=0,clockwise=true)
    clockwise ? n.next.modulo(360) : n.pred.modulo(360)
  end

  ##
  # cycle_360(n, clockwise)
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

  ##
  # circumfrence
  def circumfrence
    2 * Math::PI * ((radius_x + radius_y) / 2)
  end

  ##
  # diameter
  def diameter
    2 * ((radius_x + radius_y) / 2)
  end

end
end
end
