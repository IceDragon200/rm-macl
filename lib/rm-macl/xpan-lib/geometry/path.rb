#
# RGSS3-MACL/lib/xpan-lib/geometry/path.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 16/04/2013
# vr 0.0.1
dir = File.dirname(__FILE__)
require File.join(dir, 'point')

module MACL
  module Geometry
    class Path

      attr_accessor :points

      ##
      # initialize(Point...)
      # initialize(Array<int>[2]...)
      def initialize(*args)
        @points = args.map do |a|
          a.is_a?(Enumerable) ? MACL::Geometry::Point.new(*a[0, 1]) : a
        end
      end

      ##
      # lerp(Float delta)
      def lerp(delta=1.0)
        cindex  = ((@points.size - 1) * delta.to_f).floor
        nindex  = (cindex + 1).min(@points.size)
        x1, y1  = @points[cindex].to_a
        x2, y2  = @points[nindex].to_a
        return [x1 + (x2 - x1) * delta, y1 + (y2 - y1) * delta]
      end

      ##
      # follow(Float delta)
      def follow(delta=1.0, easer_x=nil, easer_y=nil)
        return @points[0].to_a if delta <= 0.0
        return @points[-1].to_a if delta >= 1.0
        sz         = @points.size # since size is used quite a few times
        pnt_delta  = 1.0 / sz # what is the delta between points?
        st_index   = (sz * delta).floor # Starting Node
        nx_index   = (st_index + 1) # Next Node
        nx_index = sz - 1 if nx_index >= sz
        rel_delta  = (delta - (pnt_delta * st_index)) / pnt_delta # Relative Delta
        pnt1, pnt2 = @points[st_index], @points[nx_index]
        if easer_x
          x = easer_x.ease(rel_delta, pnt1.x, pnt2.x)
        else
          x = pnt1.x + (pnt2.x - pnt1.x) * rel_delta
        end
        if easer_y
          y = easer_y.ease(rel_delta, pnt1.y, pnt2.y)
        else
          y = pnt1.y + (pnt2.y - pnt1.y) * rel_delta
        end
        return [x, y]
      end

      ##
      # mid_pnt -> Point
      def mid_pnt
        @points.inject(:+) / @points.size
      end

    end
  end
end
