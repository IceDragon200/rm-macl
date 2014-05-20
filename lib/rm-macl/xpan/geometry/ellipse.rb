#
# rm-macl/lib/rm-macl/xpan/geometry/oval.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/surface'
require 'rm-macl/xpan/geometry/path'
module MACL
  module Geometry
    class Ellipse

      include MACL::Mixin::Surface2

      attr_accessor :cx, :cy
      attr_accessor :radius_x, :radius_y
      attr_accessor :angle_offset

      ##
      # initialize(Oval oval)
      # initialize(Integer cx, Integer cy, Integer radius_x, Integer radius_y)
      def initialize(*args)
        @cx = 0
        @cy = 0
        @radius_x = 0
        @radius_y = 0
        @angle_offset = 0
        set(*args)
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

      def calc_point_from_angle(angle)
        opangle = Math::PI * (angle - @angle_offset) / 180.0
        return MACL::Vector2.new(@cx + @radius_x * Math.cos(opangle),
                                  @cy + @radius_y * Math.sin(opangle))
      end

      def calc_angle(nx, ny)
        dx, dy = nx - @cx, ny - @cy
        m = dx.abs.max(dy.abs).max(1).to_f
        return 180 + (Math.atan2((dy)/m, (dx)/m) / Math::PI) * -180 rescue 0
      end

      def calc_circ_dist(nx, ny)
        dx, dy = @cx - nx, @cy - ny
        m = dx.abs.max(dy.abs).max(1).to_f
        return (dx * Math.cos(Math::PI * dx / m)).abs + (dy * Math.cos(Math::PI * dy / m)).abs
      end

      def in_circ_area?(x, y)
        calc_circ_dist(x, y).abs <= calc_circ_dist(*calc_point_from_angle(calc_angle(x,y))).abs
      end

      ##
      # set(Oval oval)
      # set(Hash hash<Symbol, Integer>)
      #
      def set(*args)
        case args.size
        when 0
          cx, cy, rx, ry = 0, 0, 0, 0
        when 1
          arg, = args
          case arg
          when MACL::Geometry::Ellipse
            cx, cy, rx, ry = arg.cx, arg.cy, arg.radius_x, arg.radius_y
          when Hash
            cx, cy, rx, ry = arg[:cx], arg[:cy], arg[:radius_x], arg[:radius_y]
          when Array
            cx, cy, rx, ry = *arg
          else
            raise(TypeError,
                  "expected Array, Hash or MACL::Geometry::Oval but received %s" %
                    arg.class.name)
          end
        when 4
          cx, cy = args[0] || self.cx, args[1] || self.cy
          rx, ry = args[2] || self.radius_x, args[3] || self.radius_y
        else
          raise(ArgumentError, "expected 0, 1 or 4 arguments but received %s" %
                args.size)
        end
        self.radius_x, self.radius_y = rx, ry
        self.cx, self.cy = cx, cy
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
