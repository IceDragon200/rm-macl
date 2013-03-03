#
# RGSS3-MACL/lib/xpan-lib/geometry/polygon.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 0.9.0
require File.join(File.dirname(__FILE__), 'oval')

module MACL
module Geometry

class Polygon < Oval

  attr_accessor :sides

  def initialize(sides, x=0, y=0, w=0, h=0)
    super(x, y, w, h)
    @sides = sides
    @angle_offset = 180
  end

  def side_angle_size
    360.0 / @sides
  end

  def get_side_xy1(side=0) # // Exact Point
    get_angle_xy(side_angle_size * side)
  end

  def get_side_xy2(side=0, n=1) # // Line Point
    get_angle_xy((side_angle_size * side) + (side_angle_size / 2 * n))
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

  alias :get_side_xy :get_side_xy1

end

end
end
