#
# rm-macl/lib/rm-macl/xpan/geometry/path.rb
#   by IceDragon
require 'rm-macl/macl-core'
require 'rm-macl/xpan/vector'
module MACL
  module Geometry
    module Pathable

      ##
      # path_lerp(Float delta, Easer easer)
      def path_lerp(delta=1.0, easer=nil)
        pnts = points
        step = 1.0 / pnts.size
        rdel = (delta % step) / step
        cindex  = (pnts.size * delta).floor.modulo(pnts.size)
        nindex  = cindex.next.modulo(pnts.size)
        if easer
          return easer.ease(rdel, pnts[cindex], pnts[nindex])
        else
          return pnts[cindex] + (pnts[nindex] - pnts[cindex]) * rdel
        end
      end

    end

    class Path

      include Pathable

      attr_accessor :points

      ##
      # initialize(Point...)
      # initialize(Array<int>[2]...)
      def initialize(*args)
        @points = []
        args.each { |a| add_point(a) }
      end

      ##
      # add_point(point)
      def add_point(point)
        @points << Vector2.new(*point)
      end

      ##
      # mid_pnt -> Point
      def mid_pnt
        @points.inject(:+) / @points.size
      end

    end
  end
end
MACL.register('macl/xpan/geometry/path', '1.1.0')