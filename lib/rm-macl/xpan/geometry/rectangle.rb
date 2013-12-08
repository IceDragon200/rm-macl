#
# rm-macl/lib/rm-macl/xpan/geometry/rectangle.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/surface'
require 'rm-macl/xpan/geometry/path'
module MACL
  module Geometry
    class Rectangle < Path

      ##
      # Surface has its own #points method, so in order to prevent it from
      # replacing the Path#points, we alias it, and then include the
      # Surface mixin, alias the newly added #points method and then replace
      # the new #points with the #path_points
      alias :path_points :points
      include MACL::Mixin::Surface2
      alias :surface_points :points
      alias :points :path_points

      def initialize(*args)
        case args.size
        when 1
          arg, = args
          case arg
          when Rect, MACL::Geometry::Rectangle
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
        x2 = x + w
        y2 = y + h
        super([x, y], [x2, y], [x2, y2], [x, y2])
      end

      def x
        points[0].x
      end

      def y
        points[1].y
      end

      def width
        points[1].x - points[0].x
      end

      def height
        points[2].y - points[0].y
      end

      def x=(nx)
        nw = width
        points[0].x = points[3].x = nx
        points[1].x = points[2].x = nx + nw
      end

      def y=(ny)
        nh = height
        points[0].y = points[3].y = ny
        points[1].y = points[2].y = ny + nh
      end

      def width=(nw)
        nx = x
        points[1].x = points[2].x = nx + nw
      end

      def height=(nh)
        ny = y
        points[2].y = points[3].y = ny + nh
      end

    end
  end
end
MACL.register('macl/xpan/geometry/rectangle', '1.2.0')