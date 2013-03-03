#
# RGSS3-MACL/lib/xpan-lib/geometry/angle.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 0.0.1
require File.join(File.dirname(__FILE__), 'path')

module MACL
module Geometry

class Angle < Path

  attr_accessor :parent_index

  def initialize(p1, p2, p3)
    super(p1, p2, p3)
    @parent_index = 1
  end

  def parent_point
    @points[@parent_index]
  end

  def angle
    # TODO
  end

  def vertex
    # TODO
  end

end

end
end
