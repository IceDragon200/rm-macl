#
# rm-macl/lib/rm-macl/xpan/geometry/line.rb
#   by IceDragon
#   dc ??/??/2012
#   dc 03/03/2013
# vr 0.0.1
require 'rm-macl/xpan/geometry/path'
module MACL
  module Geometry
    class Line < Path

      ##
      # initialize(Point p1, Point p2)
      def initialize(p1, p2)
        super(p1, p2)
      end

    end
  end
end
