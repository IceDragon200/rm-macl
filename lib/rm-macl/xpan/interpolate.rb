#
# rm-macl/lib/rm-macl/xpan/interpolate.rb
#
# DeCasteljau Algorithm
# Hamburg (Germany), the 19th September 1999. Written by Nils Pipenbrinck aka Submissive/Cubic & $eeN
# Bezier Curve
# Ported to Ruby by IceDragon
require 'rm-macl/macl-core'
module MACL
  module Interpolate

    # // Point dest, a, b; float t
    def self.lerp(dest, a, b, t)
      dest.x = a.x + (b.x - a.x) * t
      dest.y = a.y + (b.y - a.y) * t
    end

    # // Point dest, *points; float t
    def self.bezier(dest, t, *points)
      raise(ArgumentError, "Not enough points to create bezier") if points.size < 2
      result_points = []; pnt = nil
      wpoints = points
      until wpoints.size <= 2
        for i in 0...(wpoints.size-1)
          pnt = MACL::Vector2F.new(0, 0)
          lerp(pnt, wpoints[i], wpoints[i+1], t)
          result_points << pnt
        end
        wpoints = result_points
        result_points = []
      end

      return lerp(dest,wpoints[0], wpoints[1], t)
    end

  end
end
MACL.register('macl/xpan/interpolate', '1.2.0')