#
# src/xpan-lib/interpolate.rb
#
# DeCasteljau Algorithm
# Hamburg (Germany), the 19th September 1999. Written by Nils Pipenbrinck aka Submissive/Cubic & $eeN
# Bezier Curve
# Ported to Ruby by IceDragon
module MACL
  module Interpolate

    # // Point dest, a, b; float t
    def self.lerp(dest, a, b, t)
      dest.x = a.x + (b.x - a.x) * t
      dest.y = a.y + (b.y - a.y) * t
    end

    # // Point dest, *points; float t
    def self.bezier(dest, t, *points)
      result_points = []; pnt = nil
      wpoints = points
      until wpoints.size <= 2
        for i in 0...(wpoints.size-1)
          pnt = MACL::Geometry::Point[0, 0]
          lerp pnt,wpoints[i],wpoints[i+1],t
          result_points << pnt
        end
        wpoints = result_points
        result_points = []
      end
      raise "Not enought points" if wpoints.size != 2
      lerp dest,wpoints[0],wpoints[1],t
      #ab,bc,cd,abbc,bccd = Array.new(5) { Point[0,0] }
      #lerp(ab, a,b,t)           # // point between a and b (green)
      #lerp(bc, b,c,t)           # // point between b and c (green)
      #lerp(cd, c,d,t)           # // point between c and d (green)
      #lerp(abbc, ab,bc,t)       # // point between ab and bc (blue)
      #lerp(bccd, bc,cd,t)       # // point between bc and cd (blue)
      #lerp(dest, abbc,bccd,t)   # // point on the bezier-curve (black)
    end

  end
end
