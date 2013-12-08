#
# rm-macl/lib/rm-macl/xpan/geometry/polygon.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 01/04/2013
# vr 0.9.1
require 'rm-macl/macl-core'
require 'rm-macl/xpan/geometry/ellipse'
module MACL
  module Geometry
    class Polygon < Ellipse

      include Pathable

      attr_reader :sides

      def initialize(sides, x=0, y=0, r1=0, r2=0)
        super(x, y, r1, r2)
        @sides = sides
        @angle_offset = 180
      end

      def points
        @points ||= @sides.times.map { |i| calc_side_point1(i) }
      end

      def sides=(new_sides)
        @sides = new_sides.to_i
        @points = nil
      end

      def side_angle_size
        360.0 / @sides
      end

      def calc_side_point1(side=0) # // Exact Point
        calc_point_from_angle(side_angle_size * side)
      end

      def calc_side_point2(side=0, n=1) # // Line Point
        calc_point_from_angle((side_angle_size * side) + (side_angle_size / 2 * n))
      end

      def next_side(n=0)
        n.next.modulo(@sides)
      end

      def prev_side(n=0)
        n.pred.modulo(@sides)
      end

      def cyc_side(n=0, aclockwise=false)
        aclockwise ? next_side(n) : prev_side(n)
      end

      def cycle_sides(start_side=0, aclockwise=false, n=nil)
        i = start_side
        if n
          n.times { |c| yield i, c ; i = cyc_side(i, aclockwise) }
        else
          loop do
            yield i ; i = cyc_side(i, aclockwise)
          end
        end
      end

      #alias :get_side_xy :get_side_xy1

    end
  end
end
MACL.register('macl/xpan/geometry/polygon', '1.1.0')